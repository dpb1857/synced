#!/usr/bin/env python
# pylint: disable=C0301

"""Create an initial django project directory."""

import argparse
import os
import re
import sys

class StringEditor(object):

    def __init__(self, string_data):

        self.data = string_data

    def insert(self, index, insertion):
        """Insert a substring."""

        self.data = self.data[:index] + insertion + self.data[index:]

    def delete(self, index, count):
        """Remove count characters starting at position index."""

        self.data = self.data[:index] + self.data[index+count:]


class SettingsEditor(StringEditor):

    def __init__(self, settings_data, script_name="SettingsEditor"):

        self.script_name = script_name
        self.block_start, self.block_end = 0, len(settings_data)
        super(SettingsEditor, self).__init__(settings_data)

    def _reset_block(self):

        self.block_start, self.block_end = 0, len(self.data)

    def _select_block(self, section_name):

        match = re.search(r"^%s .*?^(.*?)^[\)}]" % section_name, self.data, re.MULTILINE|re.DOTALL)
        self.block_start = match.start(1)
        self.block_end = match.end(1)

    def narrow_to_region(self, region):

        class Region(object):

            def __init__(self, settings, region):
                self.settings = settings
                self.region = region

            def __enter__(self):

                if self.region:
                    self.settings._select_block(self.region)

            def __exit__(self, *args, **kwargs):

                if self.region:
                    self.settings._reset_block()

        return Region(self, region)

    def insert(self, index, insertion):

        super(SettingsEditor, self).insert(index, insertion)
        self.block_end += len(insertion)

    def add_line_to_block_start(self, value):

        self.insert(self.block_start, "    %s, # added by %s\n" % (value, self.script_name))

    def add_line_to_block_end(self, value):

        self.insert(self.block_end, "    %s, # added by %s\n" % (value, self.script_name))

    def add_section_to_block_end(self, value):

        self.insert(self.block_end, "# Added by %s" % self.script_name)
        self.insert(self.block_end, value)

    def comment_out_block_contents(self):

        lines = self.data[self.block_start:self.block_end-1].split('\n')
        lines = ['# '+line for line in lines]
        newblock = '\n'.join(lines) + '\n'

        self.data = self.data[:self.block_start] + newblock + self.data[self.block_end:]
        self.block_end = self.block_start + len(newblock)

    def comment(self, line):
        """Comment out a line that is enabled within the selected region."""

        def re_quote(pattern):

            for special in "^.*()":
                pattern = pattern.replace(special,'\\'+special)
            return pattern

        line = re_quote(line)
        match = re.search(r"^%s" % line, self.data[self.block_start:self.block_end], re.MULTILINE)
        if match:
            self.insert(self.block_start+match.start(0), "# ")
            self.insert(self.block_start+match.start(0), "# commented out by %s\n" % self.script_name)

    def uncomment(self, line):
        """Enable a line that is commented out within the selected region."""

        def re_quote(pattern):

            for special in "^.*()":
                pattern = pattern.replace(special,'\\'+special)

            return pattern

        line = re_quote(line)
        match = re.search(r"^(\s*)(# )%s" % line, self.data[self.block_start:self.block_end], re.MULTILINE)
        if match:
            hash_location = self.block_start + match.start(2)
            self.delete(hash_location, 2)
            self.insert(self.block_start+match.start(0), "%s# uncommented by %s\n" % (match.group(1), self.script_name))

    def set_parameter_value(self, param_name, value):

        if isinstance(value, str):
            value = "'%s'" % value

        match = re.search(r"^%s = (.*)$" % param_name, self.data[self.block_start:self.block_end], re.MULTILINE)
        if match:
            self.delete(match.start(1), match.end(1)-match.start(1))
            self.insert(match.start(1), value)
            self.insert(match.start(0), "# Parameter value set by %s\n" % self.script_name)


class DjangoSettingsEditor(SettingsEditor):
    """Class to edit the settings file."""

    db_template = """
    '%(database_key)s': {
        'ENGINE': '%(engine)s',
        'NAME': '%(name)s',
        'USER': '%(user)s',
        'PASSWORD': '%(password)s',
        'HOST': '%(host)s',
        'PORT': '%(port)s',
    },
"""

    def __init__(self, settings_file, script_name="DjangoSettingsEditor"):

        self.settings_file = settings_file
        settings_data = file(settings_file).read()
        super(DjangoSettingsEditor, self).__init__(settings_data, script_name=script_name)

    def save(self):
        """Save the edited settings file."""

        file(self.settings_file, "w").write(self.data)

    def add_installed_app(self, appname, add_to_top=False):
        """Add an installed app to the django settings file."""

        with self.narrow_to_region("INSTALLED_APPS"):
            if add_to_top:
                self.add_line_to_block_start("'%s'" % appname)
            else:
                self.add_line_to_block_end("'%s'" % appname)

    def comment_out_default_database(self):
        """Comment out the default database block."""

        with self.narrow_to_region("DATABASES"):
            self.comment_out_block_contents()

    #pylint: disable=W0613,R0913
    def insert_database(self, engine, name, user='', password='', host='', port='', database_key='default'):
        """Insert a database definition block."""

        db_definition = self.db_template % locals()
        with self.narrow_to_region("DATABASES"):
            self.add_section_to_block_end(db_definition)

    def configure_sqlite_database(self, path, **kwargs):
        """Configure a sqlite database."""

        self.insert_database(engine="django.db.backends.sqlite3", name=path, **kwargs)


class DjangoUrlsEditor(SettingsEditor):
    """Class to edit the urls file."""

    def __init__(self, urls_file, script_name="DjangoUrlsEditor"):

        self.urls_file = urls_file
        urls_data = file(urls_file).read()
        super(DjangoUrlsEditor, self).__init__(urls_data, script_name=script_name)

    def save(self):
        """Save the edited settings file."""

        file(self.urls_file, "w").write(self.data)

    def add_pattern(self, pattern, add_to_top=False):

        with self.narrow_to_region("urlpatterns"):
            if add_to_top:
                self.add_line_to_block_start(pattern)
            else:
                self.add_line_to_block_end(pattern)

def add_src_pth():

    # XXX what if libdir isn't named python 2.7?
    with file("python/lib/python2.7/site-packages/src.pth", "w") as f:
        f.write("../../../../src\n")

class DirectoryContext(object):

    def __init__(self, directory):

        self.start_dir = os.getcwd()
        self.new_dir = directory

    def __enter__(self):

        os.chdir(self.new_dir)

    def __exit__(self, *args):

        os.chdir(self.start_dir)


class DjangoEnvironment(object):

    def __init__(self, app_dir, project_name, db_type="sqlite"):

        self.app_dir = app_dir
        self.project_name = project_name
        self.db_type = db_type
        self.requirements = []
        self.svn_repositories = []

        self.add_pip_requirement("django", "==1.4")
        self.add_pip_requirement("django-extensions")
        self.add_pip_requirement("south")
        self.add_pip_requirement("werkzeug")
        self.add_pip_requirement("markupsafe", "==0.15") # jinja2 faster autoescaping
        self.add_pip_requirement("jinja2")
        self.add_pip_requirement("gunicorn")
        self.add_pip_requirement("docutils") # for django admin doc pages;
        self.add_pip_requirement("pygments") # for django admin doc pages;

        project_python_path = os.path.abspath(os.path.join(app_dir, "python", "bin"))
        os.environ["PATH"] = ':'.join((project_python_path, os.environ["PATH"]))

    def add_pip_requirement(self, module, version=None):

        requirement = module if version is None else "%s%s" % (module, version)
        self.requirements.append(requirement)

    def add_svn_repository(self, url):

        self.svn_repositories.append(url)

    def create_infrastructure(self):
        """
        Create a top level directory to hold the application components and preload them:
        --> make the directory;
        --> create a virtualenv python;
        """

        # Create the application directory;
        try:
            os.mkdir(self.app_dir)
        except OSError, ex:
            if ex.errno not in (17,):
                raise

        with DirectoryContext(self.app_dir):
            # Build the python virtualenv and start a django project;

            if os.path.exists(os.path.join(os.getcwd(), "python")):
                raise OSError(17, "Virtualenv already configured.")

            os.system("virtualenv python")

            # Add a src.pth file to add top level src directory to the python path so we can use checked-out files;
            add_src_pth()

            # See if we can find an existing download directory;
            if os.path.exists(os.path.join(os.environ['HOME'], 'download')) and not os.path.exists('download'):
                os.system("ln -s $HOME/download download")

            # Install python packages
            os.system("pip install --download-cache=download %s" % ' '.join(self.requirements))
            try:
                os.mkdir("src")
            except Exception:
                pass
            with DirectoryContext("src"):
                for repository in self.svn_repositories:
                    os.system("svn co " + repository)

    def create_django_project(self):
        """
        Create the django project.
        """

        with DirectoryContext(self.app_dir):
            # Create a django project;
            os.system("django-admin.py startproject %s" % self.project_name)

    def configure_django(self):

        # Tweak the django settings;
        script_name=os.path.basename(sys.argv[0])
        settings = DjangoSettingsEditor(os.path.join(self.app_dir, self.project_name, self.project_name, "settings.py"), script_name=script_name)
        settings.add_installed_app("django_extensions")
        settings.add_installed_app("south")
        settings.add_installed_app("gunicorn")
        settings.comment("TIME_ZONE ")

        with settings.narrow_to_region("INSTALLED_APPS"):
            settings.uncomment("'django.contrib.admin'")
            settings.uncomment("'django.contrib.admindocs'")

        settings.comment_out_default_database()
        if self.db_type == "sqlite":
            settings.configure_sqlite_database(self.project_name+".sqlite")

        settings.save()

        urls = DjangoSettingsEditor(os.path.join(self.app_dir, self.project_name, self.project_name, "urls.py"), script_name=script_name)
        urls.uncomment(r"from django.contrib import admin")
        urls.uncomment(r"admin.autodiscover")
        urls.uncomment(r"url(r'^admin/doc/'")
        urls.uncomment(r"url(r'^admin/'")

        urls.save()


def main():
    """Main program body."""

    parser = argparse.ArgumentParser(description="Create a django application environment.")
    parser.add_argument('dirname', type=str,
                        help='application directory name')
    parser.add_argument('projectname', type=str, default="project", nargs="?",
                        help="django project name")
    parser.add_argument('--infrastructure-only', default=False, action='store_true',
                        help="Create a local python environment only.")

    args = parser.parse_args()

    environ = DjangoEnvironment(args.dirname, args.projectname)
    try:
        environ.create_infrastructure()
    except OSError:
        print >> sys.stderr, "Error creating virtualenv - ignored."

    if not args.infrastructure_only:
        environ.create_django_project()
        environ.configure_django()

if __name__ == "__main__":
    main()
