#!/usr/bin/env python
# pylint: disable=C0301

from django_bootstrap import *

class DjangoFilebrowserEnvironment(DjangoEnvironment):

    def __init__(self, app_dir, project_name, db_type="sqlite"):

        super(DjangoFilebrowserEnvironment, self).__init__(app_dir, project_name, db_type)
        self.add_pip_requirement("django-grappelli")
        self.add_svn_repository("http://django-filebrowser.googlecode.com/svn/trunk/filebrowser")

    def configure_django(self):

        # Create the base django setup;
        super(DjangoFilebrowserEnvironment, self).configure_django()

        # Tweak the django settings;
        script_name=os.path.basename(sys.argv[0])

        # Add applications to installed apps;
        settings = DjangoSettingsEditor(os.path.join(self.app_dir, self.project_name, "settings.py"), script_name=script_name)
        settings.add_installed_app('filebrowser', add_to_top=True)
        settings.add_installed_app('grappelli', add_to_top=True)
        
        # Set the directory for static resources;
        project_dir = os.path.abspath(self.app_dir)
        settings.set_parameter_value("STATIC_ROOT", os.path.join(project_dir, "static")+'/')
        settings.set_parameter_value("ADMIN_MEDIA_PREFIX", os.path.join(project_dir, "static", "grappelli")+'/')
        settings.set_parameter_value("MEDIA_ROOT", os.path.join(project_dir, "media")+'/')
        settings.save()
                               
        # Create media directories for filebrowser;
        try:
            os.mkdir(os.path.join(project_dir, "media"))
            os.mkdir(os.path.join(project_dir, "media", "uploads"))
        except:
            pass

        # Add urls for the filebrowser;
        urls = DjangoUrlsEditor(os.path.join(self.app_dir, self.project_name, "urls.py"), script_name=script_name)
        urls.add_pattern("(r'^grappelli/', include('grappelli.urls'))")
        urls.add_pattern("(r'^admin/filebrowser/', include('filebrowser.urls'))")
        urls.save()

    def initial_setup(self):
        
        with DirectoryContext(os.path.join(self.app_dir, self.project_name)):
            os.system("python manage.py syncdb")
            os.system("python manage.py collectstatic")


def main():
    """Main program body."""
    
    parser = argparse.ArgumentParser(description="Create a django application directory.")
    parser.add_argument('dirname', type=str,
                        help='application directory name')
    parser.add_argument('projectname', type=str, default="project", nargs="?",
                        help="django project name")

    args = parser.parse_args()
    environ = DjangoFilebrowserEnvironment(args.dirname, args.projectname)
    environ.create_infrastructure()
    environ.configure_django()
    environ.initial_setup()

if __name__ == "__main__":
    main()
