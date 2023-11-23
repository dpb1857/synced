#!/bin/bash

if [ $# -ne 1 ]; then
    echo "$0 package/appname"
    exit 1
fi

dirname=$(echo $1 | sed -e 's|^.*/||')
if [ -d $dirname ]; then
    echo "Directory $dirname already exists, exiting." 1>&2
    exit 1
fi

##################################################
# Check for commands we need for setup...
##################################################

for cmd in clojure clj npm npx patch git; do
    echo -ne "checking for installed $cmd         \r"
    sleep 0.25
    if ! type -p $cmd > /dev/null; then
        echo "'$cmd' command not found, please install." 2>&1
        exit 1
    fi
done

logfile=/tmp/kit-project-$$.log
exec 3>&1
exec > $logfile 2>&1

echo "Creating new kit app named $1" 1>&3
sleep 2

set -x

##################################################
# Create a new kit project
##################################################

clojure -Tclj-new create :template io.github.kit-clj :name $1
if [ $? -ne 0 ]; then
    echo "Kit project creation failed." 1>&3
    exit 1
fi

if [ ! -d $dirname ]; then
    echo "Kit project creation failed, exiting." 1>&3
    exit 2
fi

cd $dirname

##################################################
# Patch the version of cider in deps.edn
##################################################

echo "Patching cider-nrepl vesrsion in deps.edn" 1>&3
echo "Patching deps.edn"
patch -c <<EOF
*** deps.edn~	2023-11-12 16:09:03.703527419 -0800
--- deps.edn	2023-11-12 16:09:23.675717704 -0800
***************
*** 47,53 ****
             :nrepl {:extra-deps {nrepl/nrepl {:mvn/version "1.0.0"}}
                     :main-opts  ["-m" "nrepl.cmdline" "-i"]}
             :cider {:extra-deps {nrepl/nrepl       {:mvn/version "1.0.0"}
!                                 cider/cider-nrepl {:mvn/version "0.37.1"}}
                     :main-opts  ["-m" "nrepl.cmdline" "--middleware" "[cider.nrepl/cider-middleware]" "-i"]}

             :test {:extra-deps  {criterium/criterium                  {:mvn/version "0.4.6"}
--- 47,53 ----
             :nrepl {:extra-deps {nrepl/nrepl {:mvn/version "1.0.0"}}
                     :main-opts  ["-m" "nrepl.cmdline" "-i"]}
             :cider {:extra-deps {nrepl/nrepl       {:mvn/version "1.0.0"}
!                                 cider/cider-nrepl {:mvn/version "0.30.0"}}
                     :main-opts  ["-m" "nrepl.cmdline" "--middleware" "[cider.nrepl/cider-middleware]" "-i"]}

             :test {:extra-deps  {criterium/criterium                  {:mvn/version "0.4.6"}

EOF

##################################################
# Install kit modules
##################################################

echo "Installing kit modules :kit/html :kit/cljs" 1>&3
clj -M:dev <<EOF
(kit/sync-modules)
(kit/install-module :kit/html)
(kit/install-module :kit/cljs)
EOF

if [ $? -ne 0 ]; then
    echo "Kit module installation failed, exiting." 1>&3
    exit 3
fi

##################################################
# Patch shadow-clj.edn to run a dev http server
##################################################

echo "Patching shadow-cljs.edn to run a dev http server" 1>&3
echo "patching shadow-cljs.edn"
patch -c <<EOF
*** shadow-cljs.edn.orig	2023-11-12 17:21:11.046438712 -0800
--- shadow-cljs.edn	2023-11-12 17:24:22.263749877 -0800
***************
*** 10,13 ****
                        :asset-path "/js"
                        :modules    {:app {:entries [testing.again.core]
                                           :init-fn testing.again.core/init!}}
!                       :devtools   {:after-load testing.again.core/mount-root}}}}
--- 10,17 ----
                        :asset-path "/js"
                        :modules    {:app {:entries [testing.again.core]
                                           :init-fn testing.again.core/init!}}
!                       :devtools   {:after-load testing.again.core/mount-root}}}
!  :dev-http     {3001 {:roots ["resources/public"
!                               "resources/html"
!                               "target/classes/cljsbuild/public"]}}
!  }
EOF

##################################################
# Install tailwindcss
##################################################

echo "Install tailwindcss" 1>&3

npm install -D tailwindcss
npx tailwindcss init

##################################################
# Configure tailwind
##################################################

mkdir -p src/css
cat > src/css/tailwind.css <<EOF
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

##################################################
# Patch tailwind.config.js
##################################################

echo "Patching tailwind.config.js, setting watch patterns" 1>&3
echo "patching tailwind.config.js"
patch -c <<EOF
*** tailwind.config.js~	2023-11-01 18:28:36.733931121 -0700
--- tailwind.config.js	2023-11-05 22:47:10.249031669 -0800
***************
*** 1,9 ****
  /** @type {import('tailwindcss').Config} */
  module.exports = {
!   content: [],
    theme: {
      extend: {},
    },
    plugins: [],
  }
-
--- 1,8 ----
  /** @type {import('tailwindcss').Config} */
  module.exports = {
!   content: ["./src/**/*.cljs"],
    theme: {
      extend: {},
    },
    plugins: [],
  }
EOF

##################################################
# Create watcher script
##################################################

echo "Create watcher.sh script" 1>&3
echo "Creating watcher.sh script"
mkdir -p scripts
cat > scripts/watch.sh << EOF
#!/bin/bash
set -x
npx shadow-cljs watch app &
npx tailwindcss -i src/css/tailwind.css -o resources/public/css/tailwind.css --watch
EOF
chmod +x scripts/watch.sh

##################################################
# Upate .gitignore
##################################################

echo "Updating .gitignore" 1>&3
echo "Updating .gitignore"
cat >> .gitignore <<EOF

# Emacs;
*~, */#*#

# Tailwind
/resources/public/css/tailwind.css
EOF

##################################################
# In resources/html, symlink home.html to index.html
##################################################

echo "Linking index.html to home.html" 1>&3
echo "Linking index.html to home.html"
(cd resources/html && ln -s home.html index.html)

##################################################
# Create initial git commit
##################################################

echo "Creating initial git commit" 1>&3
echo "Creating initial git commit"
git init
git add .
git commit -m "Initial commit."

##################################################
# Install custom home.html
##################################################

echo "Create custom home.html" 1>&3
echo "Creating custom home.html"
cat > resources/html/home.html << EOF
<!DOCTYPE html>
<html lang="en" class="sm:scroll-smooth">
 <head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta name="description" content="todo: describe app here" />
  <title>Kit Project Setup</title>
   <!-- favicon -->
  <link rel="shortcut icon" href="/img/favicon.ico" type="image/x-icon" />
 <!-- styles -->
  <link href="/css/screen.css" rel="stylesheet" type="text/css" />
  <link href="/css/tailwind.css" rel="stylesheet" type="text/css" />
 </head>
 <body>
  <div id="app"></div>
  <script src="/js/app.js"></script>
 </body>
</html>
EOF

git add resources/html/home.html
git commit -m "Use custom home.html."

echo "Logfile is $logfile" 1>&3
