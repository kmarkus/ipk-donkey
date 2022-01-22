;;
;; Minimal yocto ipk package server
;;
;; SPDX-License-Identifier: BSD-3-Clause
;;

(import (chicken file)
	(chicken irregex)
	(chicken pathname)
	(chicken process-context)
	(chicken condition)
	spiffy
	fmt fmt-color
	srfi-98
	simple-directory-handler
	pathname-expand
	getopt-long)

(define (absolutize-path path)
  (let ((cwd (current-directory)))
    (if (absolute-pathname? path)
        (normalize-pathname path)
        (normalize-pathname (conc cwd "/" path)))))

(define grammar
  `((port "port on which to serve the ipks"
	  (required #f)
	  (value #t)
	  (single-char #\p)
	  (value (required PORT)
		 (transformer ,string->number)))

    (verbose "enable verbose output" (single-char #\v))
    (help    "print this"            (single-char #\h))))

(define (usage-and-exit code)
  (fmt #t "Usage: " (car (argv)) " [options...]" nl)
  (fmt #t (usage grammar))
  (exit code))

(with-exception-handler
 (lambda (exn) (print-error-message exn) (exit 1))
 (lambda ()
   (let* ((build-dir (get-environment-variable "BUILDDIR"))
	  (opts (getopt-long (command-line-arguments) grammar)))
     (when (alist-ref 'help opts)
       (usage-and-exit 0))
     (when (eq? build-dir #f)
       (fmt #t (fmt-red "error: BUILDDIR environment variable not set") nl)
       (usage-and-exit 1))
     (let* ((ipk-root (string-append build-dir "/tmp/deploy/ipk")))
       (unless (directory-exists? ipk-root)
	 (fmt #t (fmt-red "error: root-path not a directory: " ipk-root) nl)
	 (exit 2))
       (parameterize
	   ((root-path ipk-root)
	    (server-port (or (alist-ref 'port opts) 8080))
	    (handle-directory simple-directory-handler)
	    (error-log (current-error-port))
	    (access-log (if (alist-ref 'verbose opts) (current-output-port) #f)))
	 (fmt #t "serving directory " (fmt-green (root-path)) " on port " (fmt-green (server-port)) nl)
	 (start-server))))))
