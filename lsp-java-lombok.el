;;; lsp-java-lombok.el --- Lombok for Java LSP    -*- lexical-binding: t; -*-

;; Copyright (c) 2019 Seong Yong-ju

;; Author: Seong Yong-ju
;; Keywords: lombok java lsp
;; Package-Requires: ((lsp-mode "6.2.1") (f "0.20.0"))
;; Version: 1.0.0

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Lombok for Java LSP

;;; Code:

(require 'lsp-mode)
(require 'f)

(defgroup lsp-java-lombok nil
  "Lombok for Java LSP"
  :prefix "lsp-java-lombok-"
  :group 'languages)

(defcustom lsp-java-lombok-jar-path (expand-file-name
                                     (locate-user-emacs-file
                                      (f-join ".cache" "lombok.jar")))
  "The location of the Lombok JAR."
  :group 'lsp-java-lombok
  :risky t
  :type 'directory)


;;;###autoload
(defun lsp-java-lombok-download ()
  "Download the latest Lombok JAR file and install it into `lsp-java-lombok-jar-path'."
  (interactive)
  (if (and (y-or-n-p (format "Download the latest Lombok JAR into %s? "
                             lsp-java-lombok-jar-path))
           (or (not (file-exists-p lsp-java-lombok-jar-path))
               (y-or-n-p (format "The Lombok JAR already exists at %s, overwrite? "
                                 lsp-java-lombok-jar-path))))
      (progn
        (mkdir (file-name-directory lsp-java-lombok-jar-path) t)
        (message "Downloading Lombok JAR into %s" lsp-java-lombok-jar-path)
        (url-copy-file "https://projectlombok.org/downloads/lombok.jar" lsp-java-lombok-jar-path t))
    (message "Aborted.")))


;;;###autoload
(defun lsp-java-lombok ()
  "Configure lsp-java to let the server to load the Lombok JAR."
  (setq lsp-java-vmargs
        (append lsp-java-vmargs
                (list (concat "-javaagent:" lsp-java-lombok-jar-path)
                      (concat "-Xbootclasspath/a:" lsp-java-lombok-jar-path)))))


(provide 'lsp-java-lombok)

;;; lsp-java-lombok.el ends here
