; This was written in guile scheme
(use-modules (ice-9 getopt-long))

(define programs* '((blender . ((deps . (blender python35))
                                (run . (blender))))
                    (godot   . ((deps . (godot))
                              (run . (godot.x11.tools.64))))
                    (qgis    . ((deps . (qgis saga python))
                              (run . (qgis))))
                    (zap     . ((deps . (jdk7 zap))
                                (run . (zap))))))

(define (get-program program-name programs)
  (cdr (assoc program-name programs))
  )

(define (get-program-names programs)
  (map car programs)
  )

(define (exec args)
  (apply system* (map symbol->string args))
  )

(define (run-program program programs)
  (let* ((program-args-alist (get-program program programs))
         (run (cdr (assoc  'run program-args-alist)))
         (deps (cdr (assoc  'deps program-args-alist)))
         (run-cmd (append '(--run) run))
         (deps-cmd (append '(-p) deps)))
    (append '(nix-shell) deps-cmd run-cmd))
  )



(define (main args)
  (let* ((option-spec '((version (single-char #\v) (value #f))
                        (help    (single-char #\h) (value #f))
                        (list    (single-char #\l) (value #f))
                        (run     (single-char #\r) (value #t))))
         (options (getopt-long args option-spec))
         (help-wanted (option-ref options 'help #f))
         (version-wanted (option-ref options 'version #f))
         (list-wanted (option-ref options 'list #f))
         (run-wanted (option-ref options 'run #f)))
    (if (or version-wanted help-wanted run-wanted list-wanted)
        (begin
          (if list-wanted
              (display (get-program-names programs*)))
          (if version-wanted
              (display "version 0.3\n"))
          (if run-wanted
              (begin
                (display (run-program (string->symbol run-wanted) programs*)); use higher order func to refactor
                (exec (run-program (string->symbol run-wanted) programs*)))
              )
          (if help-wanted
              (display "\
nix-run [options]
  -r, --run program Runs program
  -l, --list        Display all prograsm
  -v, --version     Display version
  -h, --help        Display this help
")))
        )))
