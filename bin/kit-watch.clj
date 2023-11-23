#!/usr/bin/env bb

(require '[babashka.process :as pr])

;; npx shadow-cljs watch app &
;; npx tailwindcss -i src/css/tailwind.css -o resources/public/css/tailwind.css --watch

(let [pmeta {:in :inherit :out :inherit :err :inherit}
      p1 (pr/process pmeta "npx shadow-cljs watch app")
      p2 (pr/process pmeta "npx tailwindcss -i src/css/tailwind.css -o resources/public/css/tailwind.css --watch")]
  (pr/check p1)
  (pr/check p2))
