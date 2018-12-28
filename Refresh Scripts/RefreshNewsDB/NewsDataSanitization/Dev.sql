UPDATE wordpress_dev.wp_options set option_value = replace(option_value, 'https://news.artnet.com','http://news.dev.artnet.com') where option_id = 1; 
UPDATE wordpress_dev.wp_options set option_value = replace(option_value, 'https://news.artnet.com','http://news.dev.artnet.com') where option_id = 36; 
UPDATE wordpress_dev.wp_options set option_value = replace(option_value, 'https://news.artnet.com','http://news.dev.artnet.com') where option_id = 61; 
UPDATE  wordpress_dev.wp_options SET option_value = replace(option_value,'s:7:"sns_dev";b:0','s:7:"sns_dev";b:1') where option_name='api';
UPDATE wordpress_dev.wp_options  set option_value = '' where option_name = 'NS_SNAutoPoster';
DELETE FROM wordpress_dev.wp_sml WHERE id>1 and sml_dates is not null;
UPDATE wordpress_dev.wp_sml set sml_email = 'Artnetdev@GMAIL.com' where id >= 1; 
UPDATE wordpress_dev.wp_posts set post_content = replace(post_content, 'res.artnet.com', 'news.dev.artnet.com') where id >= 1; 
UPDATE wordpress_dev.wp_options set option_value = replace(option_value, 'res.artnet.com', 'news.dev.artnet.com') where option_id >= 1;
UPDATE wordpress_dev.wp_postmeta set meta_value = replace(meta_value, 'res.artnet.com', 'news.dev.artnet.com') where meta_id >= 1;
UPDATE wordpress_dev.wp_posts set guid = replace(guid, 'res.artnet.com', 'news.dev.artnet.com') where id >= 1; 
TRUNCATE wordpress_dev.wp_most_popular_day_hits;
UPDATE wordpress_dev.wp_comments set comment_author_url = replace(comment_author_url, 'https://news.artnet.com', 'http://news.dev.artnet.com') where comment_id >= 1; 
UPDATE wordpress_dev.wp_ewwwio_images set path = replace(path, 'https://news.artnet.com', 'http://news.dev.artnet.com') where id >= 1; 
UPDATE wordpress_dev.wp_users set user_pass='$P$B0uNz/fkV/UerFpsNOkfMJJ9nyt6Bo0' where id=1;
UPDATE wordpress_dev.wp_options set option_value = 'testing' where option_name = 'artnet_gpt_env';
UPDATE wordpress_dev.wp_options set option_value = replace(option_value, 'UA-48214041-1', 'UA-31229-10') where option_name = 'yst_ga';  
-- Line below causes ad to pop up on each page
-- UPDATE wordpress_dev.wp_banner_custom set banner_slot = replace(banner_slot,  'https://news.dev.Artnet.com', 'http://news.Artnet.com') where banner_custom_id >= 1; ->
UPDATE wordpress_dev.wp_posts set post_content = replace(post_content, 'https://news.artnet.com', 'http://news.dev.artnet.com') where id >= 1; 
UPDATE wordpress_dev.wp_postmeta set meta_value = replace(meta_value, 'https://news.artnet.com', 'http://news.dev.artnet.com') where meta_id >= 1; 
UPDATE wordpress_dev.wp_posts set guid = LEFT(replace(guid, 'https://news.artnet.com', 'http://news.dev.artnet.com'),255) where id >= 1 and length(guid)>246; 
UPDATE wordpress_dev.wp_posts set guid = replace(guid, 'https://news.artnet.com', 'http://news.dev.artnet.com') where id >= 1; 
UPDATE wordpress_dev.wp_usermeta SET meta_value=10 WHERE user_id in (305,306,307) and meta_key='wp_user_level';
UPDATE wordpress_dev.wp_usermeta SET meta_value='a:1:{s:13:"administrator";b:1;}' WHERE user_id in (305,306,307) and meta_key='wp_capabilities';
TRUNCATE wordpress_dev.wp_most_popular_day_hits;

