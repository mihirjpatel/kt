UPDATE test_cn.wp_options set option_value = replace(option_value, 'news.artnet.com','test.artnetnews.cn') where option_id = 1; 
UPDATE test_cn.wp_options set option_value = replace(option_value, 'news.artnet.com','test.artnetnews.cn') where option_id = 2; 
UPDATE test_cn.wp_options set option_value = replace(option_value, 'news.artnet.com','test.artnetnews.cn') where option_id = 58; 
UPDATE test_cn.wp_options SET option_value = replace(option_value,'s:7:"sns_dev";b:0','s:7:"sns_dev";b:1') where option_name='api';
UPDATE test_cn.wp_comments set comment_author_url = replace(comment_author_url, 'artnetnews.cn', 'test.artnetnews.cn') where comment_id >= 1; 
UPDATE test_cn.wp_ewwwio_images set path = replace(path, 'artnetnews.cn', 'test.artnetnews.cn') where id >= 1; 
UPDATE test_cn.wp_postmeta set meta_value = replace(meta_value, 'artnetnews.cn', 'test.artnetnews.cn') where meta_id >= 1; 
UPDATE test_cn.wp_posts set post_content = replace(post_content, 'artnetnews.cn', 'test.artnetnews.cn') where id >= 1; 
UPDATE test_cn.wp_posts set guid = replace(guid, 'artnetnews.cn', 'test.artnetnews.cn') where id >= 1; 
UPDATE test_cn.wp_sml set sml_email = 'Artnettest@GMAIL.com' where id >= 1; 
UPDATE test_cn.wp_options  set option_value = '' where option_name = 'NS_SNAutoPoster';
UPDATE test_cn.wp_users set user_pass='$P$B0uNz/fkV/UerFpsNOkfMJJ9nyt6Bo0' where id=1;
UPDATE test_cn.wp_options set option_value = replace(option_value, 'UA-48214041-1', 'UA-31229-10') where option_name = 'yst_ga';  
UPDATE test_cn.wp_options set option_value = 'testing' where option_name = 'artnet_gpt_env';
UPDATE test_cn.wp_adrotate set image = replace(image, 'artnetnews.cn', 'test.artnetnews.cn')where id >= 1;
UPDATE test_cn.wp_postmeta set meta_value = replace(meta_value, 'news.artnet.com', 'test.artnetnews.cn') where meta_id >= 1; 
UPDATE test_cn.wp_posts set post_content = replace(post_content, 'news.artnet.com', 'test.artnetnews.cn') where id >= 1; 
UPDATE test_cn.wp_usermeta SET meta_value=10 WHERE user_id in (274,275,276) and meta_key='wp_user_level';
UPDATE test_cn.wp_usermeta SET meta_value='a:1:{s:13:"administrator";b:1;}' WHERE user_id in (274,275,276) and meta_key='wp_capabilities';