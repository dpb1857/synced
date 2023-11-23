#!/usr/bin/env bb

(require '[babashka.process :as pr]
         '[babashka.fs :as fs]
         '[clojure.string :as str]
         '[clojure.pprint :refer [pprint]])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Utility Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Apply a diff uising patch;

(defn apply-patch
  "Apply a diff using patch."
  [message dir patch-data]

  (println "** " message)
  (println "+patch -c ...")
  (let [patch (pr/process {:dir dir} "patch")]
    (spit (:in patch) patch-data)))

;; Edit a file;

(defn edit-file
  "Edit a file, replacing patt1 with patt2."
  [fname patt1 patt2]

  (println (format "** edit file %s: replace \"%s\" with \"%s\"" fname patt1 patt2))
  (spit fname (str/replace (slurp fname) patt1 patt2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; startup checks & help
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn help-message []
  (prn "Usage:  kit-project.clj <projectname>")
  (System/exit 1))

(defn error-exit
  "Print an error message and exit with a code."
  [message exit-code]

  (when message
    (println message))
  (System/exit exit-code))

(defn verify-project-name
  "Verify project name, returns directory name."
  [project]
  (let [parts (str/split project #"/")]
    (if (not= (count parts) 2)
      (error-exit (format "Projectname must have one slash: %s" project) 1)
      (parts 1))))

(defn check-directory-already-created [dirname]
  (when (fs/exists? dirname)
    (error-exit (format "Directory '%s' already exists." dirname) 2)))

(defn verify-software-installed
  "Verify that commands we need have been installed."
  []

  (println "** Verify software is installed")
  (doseq [cmd ["clojure" "clj" "npm" "npx" "patch" "git"]]
    (print "Verify " cmd " command...\r")
    (flush)
    (pr/shell "sleep 0.3")
    (when (not (fs/which cmd))
      (error-exit (format "'%s': command not found, please install." cmd) 1)
      )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Do setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn create-kit-project
  "Create a new kit project."
  [project]

  (println "** Creating kit project" project)
  (let [cmd (format "clojure -Tclj-new create :template io.github.kit-clj :name %s" project)]
    (println "+" cmd)
    (-> (pr/shell cmd)
        pr/check)
    ))

(defn install-kit-modules
  "Install base kit modules we would like to have."
  [dirname]

  (println "** Install base kit modules")
  (let [cmd "clojure -M:dev -e '(kit/sync-modules) (kit/install-module :kit/html) (kit/install-module :kit/cljs)'" ]
    (println "+" cmd)
    (pr/shell {:dir dirname} cmd)))

(defn add-shadow-http-server
  "Add a dev http server to the shadow-cljs config."
  [dirname]

  (println "** Add dev http server to shdow-cljs.edn")
  (let [fname (fs/path dirname "shadow-cljs.edn")
        data (read-string (slurp fname))
        update (assoc data
                      :dev-http
                      {3001 {:roots
                             ["resources/public"
                              "resources/html"
                              "target/classes/cljsbuild/public"]}})]

    (spit fname (with-out-str (pprint update)))))


;;;;;  src/css/tailwind.css

(def tailwind-css
  "@tailwind base;
@tailwind components;
@tailwind utilities;
")

(defn install-tailwind
  "Install and configure tailwindcss."
  [dirname]

  (println "** Install and configure tailwindcss")
  (doseq [cmd ["npm install -D tailwindcss"
               "npx tailwindcss init"
               "mkdir -p src/css"]]
    (println "+" cmd)
    (pr/shell {:dir dirname} cmd))

  (println "** Create file src/css/tailwind.css")
  (spit (fs/path dirname "src/css/tailwind.css") tailwind-css)
  (edit-file (fs/path dirname "tailwind.config.js") "content: []" "content: [\"./src/**/*.cljs\"]"))

;;;;; scripts/watch.sh

(def watch-script
"#!/bin/bash
set -x
npx shadow-cljs watch app &
npx tailwindcss -i src/css/tailwind.css -o resources/public/css/tailwind.css --watch
")

(defn create-watcher-script [dirname]
  (println "** adding watcher script")
  (fs/create-dirs (fs/path dirname "scripts"))
  (let [fname (fs/path dirname "scripts/watch.sh")]
    (spit fname  watch-script)
    (fs/set-posix-file-permissions fname "rwxr-xr-x")))

;;;;; .gitignore

(def gitignore-additions
"
# Emacs;
*~, */#*#

# Tailwind
/resources/public/css/tailwind.css
")


(defn update-gitignore [dirname]
  (println "** Adding ignore patterns to .gitignore")
  (spit (fs/path dirname ".gitignore") gitignore-additions :append true))

;;;;; resources/html/home.html

(def home-html
"<!DOCTYPE html>
<html lang=\"en\" class=\"sm:scroll-smooth\">
 <head>
  <meta charset=\"UTF-8\" />
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />
  <meta name=\"description\" content=\"todo: describe app here\" />
  <title>Kit Project Setup</title>
   <!-- favicon -->
  <link rel=\"shortcut icon\" href=\"/img/favicon.ico\" type=\"image/x-icon\" />
 <!-- styles -->
  <link href=\"/css/screen.css\" rel=\"stylesheet\" type=\"text/css\" />
  <link href=\"/css/tailwind.css\" rel=\"stylesheet\" type=\"text/css\" />
 </head>
 <body>
  <div id=\"app\"></div>
  <script src=\"/js/app.js\"></script>
 </body>
</html>
")

(defn fixup-index-html [dirname]
  (println "** Install custom resources/html/home.html")
  (spit (fs/path dirname "resources/html/home.html") home-html)
  (fs/create-sym-link (fs/path dirname "resources/html/index.html") "home.html")
  )

(defn create-initial-git-commit [dirname]
  (println "** Create initial git commit")
  (doseq [cmd ["git init"
               "git add ."
               "git commit -m \"Initial commit.\""]]
    (println "+" cmd)
    (pr/shell {:dir dirname} cmd)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main entry point
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn main []
  (when (not= (count *command-line-args*) 1)
    (help-message))

  (let [project (first *command-line-args*)
        dirname (verify-project-name project)
        ]
    (check-directory-already-created dirname)
    (verify-software-installed)
    (create-kit-project project)
    (edit-file (fs/path dirname "deps.edn") "0.37.1" "0.30.0")
    (install-kit-modules dirname)
    (add-shadow-http-server dirname)
    (install-tailwind dirname)
    (create-watcher-script dirname)
    (update-gitignore dirname)
    (fixup-index-html dirname)
    (create-initial-git-commit dirname)
    ))

(main)
