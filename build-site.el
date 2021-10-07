;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)


;; Load the publishing system
(require 'ox-publish)

  (setq my-blog-header-file "./css/header.html"
        my-blog-footer-file "./css/footer.html"
        org-html-validation-link nil
        org-html-head-include-scripts nil       ;; Use our own scripts
        org-html-head-include-default-style nil ;; Use our own styles
        ;; org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />")
        org-html-head "<link rel=\"stylesheet\" href=\"css/stylesheet.css\" />")

  ;; Load partials on memory
  (defun my-blog-header (arg)
    (with-temp-buffer
      (insert-file-contents my-blog-header-file)
      (buffer-string)))

  (defun my-blog-footer (arg)
    (with-temp-buffer
      (insert-file-contents my-blog-footer-file)
      (buffer-string)))

  (defun filter-local-links (link backend info)
    "Filter that converts all the /index.html links to /"
    (if (org-export-derived-backend-p backend 'html)
        (replace-regexp-in-string "/index.html" "/" link)))

  (setq org-publish-project-alist
        '(;; Publish the posts
          ("pages"
           :base-directory "./org-files"
           :base-extension "org"
           :publishing-directory "./"
           :recursive t
           :publishing-function org-html-publish-to-html
           :headline-levels 4
           :section-numbers nil
           :with-toc nil
           ;; :html-head nil
           ;; :html-head-include-default-style nil
           ;; :html-head-include-scripts nil
           :html-preamble my-blog-header
           :html-postamble my-blog-footer
           )

          ;; For static files that should remain untouched
          ("img"
           :base-directory "./org-files"
           :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|eot\\|svg\\|woff\\|woff2\\|ttf\\|html"
           :publishing-directory "./"
           :recursive t
           :publishing-function org-publish-attachment
           )

          ;; Combine the two previous components in a single one
          ("homepage" :components ("pages" "img"))
))


;; Generate the site output
(org-publish-all t)

(message "Build complete!")
