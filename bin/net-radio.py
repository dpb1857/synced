#!/usr/bin/python

import os
import signal
import stat
import string
import sys
import thread
import time

# External programs used:
#
# /usr/bin/lame  package: lame 
# /usr/bin/streamripper
# /usr/bin/mp3info
# /usr/bin/mplayer
#
# Checkout: kradioripper



# PROGRAM_DIR = "/home/audio"
PROGRAM_DIR = "/mnt/nas/media/radio"

##################################################

REC_MPLAYER_STREAM = 0
REC_OGG_STREAM     = 1
REC_MP3_STREAM     = 2

stations = {
  # "KALW" : ("http://www.kalw.org/media/Streaming%20Links/kalw_stream.ram", REC_MPLAYER_STREAM),
  "KALW" : ("http://live.str3am.com:2430/", REC_MP3_STREAM),
  "KCSM" : ("http://hifi.kcsm.org:8040/vorbis2.ogg", REC_OGG_STREAM),
  "KFJC" : ("http://netcast.kfjc.org:8976", REC_MP3_STREAM),
  "KUOW" : ("http://128.208.34.80:8002/", REC_MP3_STREAM),
  "KUOW2": ("http://www.kuow.org/kuow2.asx", REC_MPLAYER_STREAM),
  "KPBS" : ("http://www.kpbs.org/kpbs64k.asx", REC_MPLAYER_STREAM),
}

programs = {
    "BehindTheBarn":        ("KFJC", 14400, "schedule"),
    "MyWord":               ("KALW", 1560, "schedule"),
    "FolkMusic":            ("KALW", 7200, "schedule"),
    "FreshAir":             ("KALW", 3600, "schedule"),
    "PrarieHomeCompanion" : ("KUOW", 7200, "schedule"),
    "SelectedShorts":       ("KUOW", 3600, "schedule"),
    # "ThisAmericanLife":     ("KUOW", 3600, "schedule"),
    "ThisAmericanLife":     ("KALW", 3600, "schedule"),
    "ThistleAndShamrock":   ("KALW", 3600, "schedule"),
    "WestCoastLive":        ("KALW", 7200, "schedule"),
    "KFJCTest":             ("KALW", 60,   "schedule"),
    "KUOWTest":             ("KUOW", 60,   "schedule"),
    "KALWTest":             ("KALW", 30,   "schedule"),
}

artists = {
    "BehindTheBarn"       : ("Peggy O.", "Country"),
    "FolkMusic"           : ("JoAnn Mar & Bob Campbell", "Celtic"),
    "FreshAir"            : ("Terry Gross", "Speech"),
    "MyWord"              : ("BBC", "Speech"),
    "PrarieHomeCompanion" : ("Garrison Keillor", "Humour"),
    "SelectedShorts"      : ("Isaiah Sheffer", "Speech"),
    "ThisAmericanLife"    : ("Ira Glass", "Speech"),
    "ThistleAndShamrock"  : ("Fiona Ritchie", "Celtic"),
    "WestCoastLive"       : ("Sedge Thomson", "Humour"),

    "KALWTest"            : ("KALW Test Artist", "Speech"),
    "KFJCTest"            : ("KFJC Test Artist", "Speech"),
    "KUOWTest"            : ("KUOW Test Artist", "Speech"),
    "KUOW2Test"           : ("KUOW2 Test Artist", "Speech"),
    "KNAUTest"            : ("KNAU Test Artist", "Speech")
}

def find_token_start(str, pos):
    l = len(str)
    while pos < l and (str[pos] == " " or str[pos] == "\t"):
        pos += 1
    return pos

def find_token(str, pos):
    l = len(str)
    chars = []
    endtest = " "
    while pos < l:
        # backslash processing;
        if str[pos] == '\\' and pos+1 < l:
            chars.append(str[pos+1])
            pos += 1
        
        # quoted string processing;
        elif endtest != " ":
            if endtest == str[pos]:
                endtest = " "
            else:
                chars.append(str[pos])

        # Check for end of token;
        elif str[pos] == " " or str[pos] == "\t":
            break

        # Ordinary text processing;
        else:
            if str[pos] == "'" or str[pos] == '"':
                endtest = str[pos]
            else:
                chars.append(str[pos])

        pos += 1

    return (string.join(chars,''), pos)


def parse(str):
    l = len(str)
    tokens = []

    pos = 0
    while pos < l:
        start = find_token_start(str, pos)
        if start < l:
            token, pos = find_token(str, start)
            tokens.append(token)

    return tokens

def parse_cmd_string(cmd_string):
    return parse(cmd_string)

def pkiller(pid, timeout):
    time.sleep(timeout)
    os.kill(pid, signal.SIGINT)

def new_process(cmd_string, stdin, stdout, stderr, timeout):
    cmd = parse_cmd_string(cmd_string)
    new_pid = os.fork()
    if new_pid == 0:
	# child
	os.dup2(stdin, 0)
	os.dup2(stdout, 1)
	os.dup2(stderr, 2)
	os.execvp(cmd[0], cmd)

    if timeout > 0:
	thread.start_new_thread(pkiller, (new_pid, timeout))

    return new_pid

def ogg_stream(url, filename, duration, metadata):
    null = file("/dev/null", "rw")
    p = os.pipe()
    capture_pid = new_process("ogg123 -q -d wav -f - %(url)s" % vars(), 0, p[1], null.fileno(), duration)
    showname, datestr, artist, genre = metadata
    encode_pid = new_process("/usr/bin/lame -h --quiet --tt \"%(showname)s %(datestr)s\" --tl %(showname)s --tg Radio - %(filename)s" % vars(), p[0], 1, null.fileno(), 0)
    os.waitpid(capture_pid, 0)
    os.kill(encode_pid, signal.SIGHUP)

def mp3_stream(url, filename, duration, metadata):
    null = file("/dev/null", "rw")
    my_pid = os.getpid()
    ripper_pid = new_process("/usr/bin/streamripper %(url)s -a %(filename)s -l %(duration)d -s -A --quiet" % vars(), 0, 1, 2, 0)
    os.waitpid(ripper_pid, 0)

    if filename[-4:] == ".mp3": 
	cuefile = filename[:-4] + ".cue"
    else:
	cuefile = filename + ".cue"
	filename = filename + ".mp3"
	
    os.unlink(cuefile)

    # The KUOW header seems to confuse the slimserver I'm currently using(6.5.1); re-encode to keep it happy.
    convert_pid = new_process("/usr/bin/lame --mp3input %s %s.new" % (filename, filename), 0, null.fileno(), null.fileno(), 0)
    os.waitpid(convert_pid, 0)
    os.unlink(filename)
    os.rename(filename+".new", filename)

    # Since we're not using lame to generate the mp3, add the tags now;
    showname, datestr, artist, genre = metadata
    os.system("/usr/bin/mp3info -t \"%(showname)s %(datestr)s\" -a \"%(artist)s\" -l \"%(showname)s\" -g \"%(genre)s\" %(filename)s" % vars())

def mplayer_stream(url, filename, duration, metadata):
    if url[-4:] == ".pls" or url[-4:] == ".ram" or url[-4:] == ".asx":
	url_arg = "-playlist %s" % url
    else:
	url_arg = url

    null = file("/dev/null", "rw")
    pid = os.getpid()
    pipe_name = "/tmp/pcm_audio.%(pid)d" % vars()
    os.mknod(pipe_name, 0600|stat.S_IFIFO)
    capture_pid = new_process("/usr/bin/mplayer -cache 512 -ao pcm:waveheader -ao pcm:file=%(pipe_name)s -vc dummy -vo null %(url_arg)s" % vars(), 0, null.fileno(), null.fileno(), duration)
    showname, datestr, artist, genre = metadata
    encode_pid = new_process("/usr/bin/lame -h --quiet --tt \"%(showname)s %(datestr)s\" --tl %(showname)s --ta \"%(artist)s\" --tg %(genre)s %(pipe_name)s %(filename)s" % vars(), 0, 1, null.fileno(), 0)
    os.waitpid(capture_pid, 0)
    os.waitpid(encode_pid, 0)
    os.unlink(pipe_name)

methods = [mplayer_stream, ogg_stream, mp3_stream]


def record_station(station, duration):
    url, method = stations[station]
    datestr = time.strftime("%Y-%m-%d-%H:%M")
    filename = os.path.join(PROGRAM_DIR, "%(station)s-%(datestr)s.mp3" % vars())
    methods[method](url, filename, duration, (station, datestr, station, "Speech"))

def record_program(program_name):
    station, duration, schedule = programs[program_name]
    artist, genre = artists[program_name]
    url, method = stations[station]
    datestr = time.strftime("%Y-%m-%d")
    dir = os.path.join(PROGRAM_DIR, program_name, time.strftime("%Y"))
    try: os.makedirs(dir)
    except: pass
    filename = os.path.join(dir, "%(program_name)s-%(datestr)s.mp3" % vars())

    print "URL:", url
    print "filename:", filename
    print "duration:", duration

    
    methods[method](url, filename, duration, (program_name, datestr, artist, genre))

############################################################
# Main script body;
############################################################

# ogg_stream("http://hifi.kcsm.org:8040/vorbis2.ogg", "/big/radio/tmp/test.mp3", 15)
# mp3_stream("http://netcast.kfjc.org:8976", "/big/radio/tmp/mp3test.mp3", 15)
# mplayer_stream("http://www.kalw.org/kalw_stream.ram", "/big/radio/tmp/mpstream.mp3", 10)

# record_program("KALWTest")
# record_program("KUOWTest")
# sys.exit(1)

def usage_programs():
    print >> sys.stderr, "Programs:"
    keys = programs.keys()
    keys.sort()
    for key in keys:
        print >> sys.stderr, "  %s" % key

def usage_stations():
    print >> sys.stderr, "Stations:"
    keys = stations.keys()
    keys.sort()
    for key in keys:
        print >> sys.stderr, "  %s" % key

def usage():
    print >> sys.stderr, "%s program <program-name>" % sys.argv[0]
    print >> sys.stderr, "%s station <station> <duration>" % sys.argv[0]
    usage_programs()
    usage_stations()
    sys.exit(1)

if len(sys.argv) < 2:
    usage()

if sys.argv[1] == "program":
    if len(sys.argv) < 3:
	usage()
    program = sys.argv[2]
    if programs.has_key(program):
	record_program(program)
    else:
	print >> sys.stderr, "Invalid program:"
	usage_programs()
	sys.exit(2)

elif sys.argv[1] == "station":
    if len(sys.argv) < 4:
	usage()
    station = sys.argv[2]
    duration = int(sys.argv[3])
    if stations.has_key(station):
	record_station(station, duration) # station, duration
    else:
	print >> sys.stderr, "Invalid station."
	usage_stations()
	sys.exit(3)

else:
    usage()

sys.exit(0)
