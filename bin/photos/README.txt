
Suggested order of business -

1) Copy the files from the SD card to ~/tmp/Photos, like so:
   cd /media/dpb
   rsync -av 3531-6538 /mnt/space/tmpphotos

   At this point, you can clear the SD card anytime after you backup the laptop.

2) Jigger the files around;
   move the photo directories, like 121_PANA, to the top level;
   move the movie files, like STREAM/* to the top level;

3) Find a proper name for the directory;
   Run the script nameGx7Folder.py to look at the file timestamps and create name.

4) Convert the STREAM/*.MTS files to MP4 files;
   mts2mp4.sh
   Then nuke the STREAM directory.

This would be a good time to backup the laptop.

5) View with digikam, get rid of the obious junk;
   remove .Trash-* directories;

6) Run:
   cleanupRW2.sh
   to get rid of rw2 files with no matching jpg file.

7) Run:
   fixTimestamps.sh 121_PANA (or whereever)
   to fix timestamps on jpg files we may have tweaked in digikam; (rotation, stars, etc.)

8) Push the "developed" photos to the photos drive;
   rsync gx7-2018-1120-1124-121-0144-0451 /media/dpb/PhotoArchive/archive

9) run Push.sh to execute PushToSmugmug.sh and PushToPreview.sh to "publish" photos;

10) Go to Smugmug and import the photos pushed to Dropbox for Smugmug consumption;

11) At some point, backup the Photos drive -
    photosBackup.sh

12) If kept on laptop, move photos directory to /mnt/space/scratch/Photos;
