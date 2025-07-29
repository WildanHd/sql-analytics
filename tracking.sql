WITH filtered_activities AS (
    SELECT
        timestamp,
        fingerprint,
        user_id,
        post_slug,
        referrer,
        -- Normalize action
        CASE
            WHEN action = 'Login' THEN 'login'
            WHEN action = 'Register' THEN 'register'
            WHEN action = 'Read' THEN 'read'
            WHEN action = 'chec' THEN 'checkout'
            WHEN action = 'Pay' THEN 'pay'
            ELSE action
        END AS norm_action,

        -- Normalize name
        CASE
            WHEN name = 'Landing Page' THEN 'landing_page'
            WHEN name = 'Checkout' THEN 'checkout'
            WHEN name = 'detail_artic' THEN 'detail_article'
            WHEN name ILIKE '%category%' THEN 'category'
            WHEN name ILIKE '%checkout%' THEN 'checkout'
            WHEN name ILIKE '%comment%' THEN 'comment'
            WHEN name ILIKE '%payment%' THEN 'payment'
            ELSE name
        END AS norm_name
    FROM user_activities
    WHERE
        fingerprint <> ''
        AND DATE(timestamp) BETWEEN '%s' AND '%s'
        AND fingerprint IN (
            SELECT fingerprint
            FROM website_activities
            WHERE user_id = %s
              AND fingerprint <> ''
              AND DATE(timestamp) BETWEEN '%s' AND '%s'
        )
)

SELECT
    timestamp,
    fingerprint,
    user_id,
    norm_action AS action,
    norm_name AS name,
    post_slug,
    referrer,
    CASE
        WHEN norm_action = 'read' AND norm_name = 'detail_article' THEN 'b_reach'
        WHEN norm_action = 'register' AND norm_name = 'authentication' THEN 'c_register'
        WHEN norm_action = 'login' AND norm_name = 'authentication' THEN 'd_login'
        WHEN norm_action = 'read' AND norm_name = 'landing_page' THEN 'e_landing_page'
        WHEN norm_action = 'checkout' AND norm_name = 'landing_page' THEN 'f_subscribe_click'
        WHEN norm_action = 'read' AND norm_name = 'checkout' THEN 'g_checkout'
        WHEN norm_action = 'pay' AND norm_name = 'checkout' THEN 'h_payment_click'
        WHEN norm_action = 'successful' AND norm_name = 'checkout' THEN 'i_payment_done'
        ELSE 'a_others'
    END AS journey
FROM filtered_activities
ORDER BY fingerprint, timestamp;
