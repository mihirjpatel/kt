UPDATE wordpress.wp_options set option_value = replace(option_value, 'news.artnet.com','news.staging.artnet.com') where option_id = 1; 
UPDATE wordpress.wp_options set option_value = replace(option_value, 'news.artnet.com','news.staging.artnet.com') where option_id = 36; 
UPDATE wordpress.wp_options set option_value = replace(option_value, 'news.artnet.com','news.staging.artnet.com') where option_id = 61;
UPDATE  wordpress.wp_options SET option_value = replace(option_value,'s:7:"sns_dev";b:0','s:7:"sns_dev";b:1') where option_name='api';
UPDATE wordpress.wp_options  set option_value = '' where option_name = 'NS_SNAutoPoster';
DELETE FROM wordpress.wp_sml WHERE id>1 and sml_dates is not null;
UPDATE wordpress.wp_sml set sml_email = 'Artnetstaging@GMAIL.com' where id >= 1; 
UPDATE wordpress.wp_posts set post_content = replace(post_content, 'res.artnet.com', 'news.staging.artnet.com') where id >= 1; 
UPDATE wordpress.wp_options set option_value = replace(option_value, 'res.artnet.com', 'news.staging.artnet.com') where option_id >= 1;
UPDATE wordpress.wp_postmeta set meta_value = replace(meta_value, 'res.artnet.com', 'news.staging.artnet.com') where meta_id >= 1;
UPDATE wordpress.wp_posts set guid = replace(guid, 'res.artnet.com', 'news.staging.artnet.com') where id >= 1; 
TRUNCATE wordpress.wp_most_popular_day_hits;
UPDATE wordpress.wp_comments set comment_author_url = replace(comment_author_url, 'news.artnet.com', 'news.staging.artnet.com') where comment_id >= 1; 
UPDATE wordpress.wp_ewwwio_images set path = replace(path, 'news.artnet.com', 'news.staging.artnet.com') where id >= 1; 
UPDATE wordpress.wp_users set user_pass='$P$B0uNz/fkV/UerFpsNOkfMJJ9nyt6Bo0' where id=1;
UPDATE wordpress.wp_options set option_value = 'testing' where option_name = 'artnet_gpt_env';
UPDATE wordpress.wp_options set option_value = replace(option_value, 'UA-48214041-1', 'UA-31229-10') where option_name = 'yst_ga';  
-- Line below causes ad to pop up on each page
-- UPDATE wordpress.wp_banner_custom set banner_slot = replace(banner_slot,  'news.staging.Artnet.com', 'News.Artnet.com') where banner_custom_id >= 1; ->
UPDATE wordpress.wp_posts set post_content = replace(post_content, 'news.artnet.com', 'news.staging.artnet.com') where id >= 1; 
UPDATE wordpress.wp_postmeta set meta_value = replace(meta_value, 'news.artnet.com', 'news.staging.artnet.com') where meta_id >= 1; 
UPDATE wordpress.wp_posts set guid = LEFT(replace(guid, 'news.artnet.com', 'news.staging.artnet.com'),255) where id >= 1 and length(guid)>246; 
UPDATE wordpress.wp_posts set guid = replace(guid, 'news.artnet.com', 'news.staging.artnet.com') where id >= 1; 
UPDATE wordpress.wp_usermeta SET meta_value=10 WHERE user_id in (305,306,307,335) and meta_key='wp_user_level';
UPDATE wordpress.wp_usermeta SET meta_value='a:1:{s:13:"administrator";b:1;}' WHERE user_id in (305,306,307,335) and meta_key='wp_capabilities';
TRUNCATE wordpress.wp_most_popular_day_hits;