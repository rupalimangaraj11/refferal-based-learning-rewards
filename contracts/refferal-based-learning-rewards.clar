(define-map users (principal) bool)
(define-map referrals (principal) uint)

(define-constant reward-amount u100)

;; Register a user with an optional referrer
(define-public (register-user (referrer (optional principal)))
  (begin
    ;; Ensure the user is not already registered
    (asserts! (is-none (map-get? users tx-sender)) (err u400))
    ;; Mark the user as registered
    (map-set users tx-sender true)

    ;; If referrer is provided and valid, reward them
    (match referrer ref
      (begin
        (asserts! (is-some (map-get? users ref)) (err u401)) ;; Referrer must be a registered user
        (map-set referrals ref (+ (default-to u0 (map-get? referrals ref)) u1))
        ;; Reward transfer logic can be added here
        (ok true)
      )
      (ok true)
    )
  )
)

;; Get referral count for any user
(define-read-only (get-referral-count (user principal))
  (ok (default-to u0 (map-get? referrals user))))
