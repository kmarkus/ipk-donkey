;;
;; Minimal yocto ipk package server
;;

(use spiffy fmt fmt-color posix irregex
     simple-directory-handler
     simple-configuration
     pathname-expand)

(define (write-default-dot-file fn)
  (with-output-to-file fn
    (lambda () (fmt #t
		    "((server-port 8080)" nl
		    " (logging-enabled #t))" nl))))

(let* ((build-dir (get-environment-variable "BUILDDIR")))
  (when (eq? build-dir #f)
	(fmt #t (fmt-red "error: BUILDDIR environment variable not set") nl)
	(exit 1))
  (let* ((ipk-root (string-append build-dir "/tmp/deploy/ipk"))
	 (dot-file (pathname-expand "~/.ipk-donkey")))
    (unless (directory-exists? ipk-root)
	    (fmt #t (fmt-red "error: root-path not a directory: " ipk-root) nl)
	    (exit 2))
    (unless (file-exists? dot-file)
	    (write-default-dot-file dot-file))
    (let ((cfg (config-read dot-file eval-config: #t)))
      (parameterize
       ((root-path ipk-root)
	(server-port (config-ref cfg '(server-port) default: 80))
	(handle-directory simple-directory-handler)
	(error-log (current-error-port))
	(access-log (if (config-ref cfg '(logging-enabled))
			(current-output-port) #f)))
       (fmt #t "serving directory " (fmt-green (root-path)) " on port " (fmt-green (server-port)) nl)
       (start-server)))))
