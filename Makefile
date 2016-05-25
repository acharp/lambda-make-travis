REGION := eu-west-1

# generate the zip
generate:
	zip -r ./ProcessEvent.zip ./main


# upload the zip to update aws lambda code
upload:
	aws lambda update-function-code --function-name process_kinesis-event \
		--zip-file fileb://$(HOME)/ProcessEvent.zip \
		--region $(REGION) \


# send event to stream to test the new lambda function
testi:
	aws kinesis put-record --stream-name test-process-event-toES --data '{"device_is_touch_capable": false, "dapi_version": "1.4.0-7a16d2d335d4f8cb69c2541182c86316b0b9b4e0", "ip": "66.102.6.237", "ga_screen_colors": "24-bit", "place_id": "91130", "client_timestamp": "2016-05-15T15:59:11.235-07:00", "currency": "NZD", "browser_version": "11", "rooms": "2", "device_type": "desktop", "ga_encoding": "utf-8", "ga_screen_resolution": "1024x768", "id": "mhPNCSmtg2RlJvTLK1pqWDalnzevVQVpcJ7C", "ga_campaign_name": "", "check_in": "", "user_agent": "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko", "server_timestamp": "1.4633531508304734E9", "ga_flash_version": "17.0 r0", "ga_campaign_medium": "", "device_model": "", "os_version": "", "ga_java_enabled": "true", "ga_campaign_content": "", "page_type": "PlacePage", "app_version": "1.0.0.rc45-136-gc881963-c881963e613c6dd92f8a5ae441db3104daa49e04", "ga_exp_var": "", "search_id": "", "gtm_container_version": "46", "ga_title": "FindHotel - Hotels in Waiheke Island, Auckland, New Zealand", "browser_major": 11, "ga_campaign_source": "", "ga_campaign_keyword": "", "hotel_id": "", "device_brand": "", "api_id": "", "client_id": "750406447.1463353151", "layout": "desktop", "api_stage": "prod", "check_out": "", "server_session_id": "innotrvl_784357", "api_key": "LUyvXJoTAG3d5JZKOvGi53AUhzHYemfM80MleVEz", "language": "en-GB", "url": "http://hotels.findhotel.co.nz/Place/Waiheke_Island.htm?Location&Label=codetype%3D0%26clicktype%3DA%26placeid%3D91130%26campaignid%3D8401%26adgroupid%3D14425130%26targetcode%3DNZ%26headlineid%3D1%26desclayoutid%3D10%26desclayoutvn%3D1", "ga_campaign_id": "", "os_major": "", "ga_exp_id": "", "device_family": "Other", "polku_version": "v1.1.0-23b2dd121ec56d95d6f04d2b0f012f28e387cce5", "referrer_url": "http://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=4&ved=0CEQQFjAF&url=http%3A%2F%2Fhotels.findhotel.co.nz%2FPlace%2FWaiheke_Island.htm%3FLocation%26Label%3Dcodetype%253D0%2526clicktype%253DA%2526placeid%253D91130%2526campaignid%253D8401%2526adgroupid%253D14425130%2526targetcode%253DNZ%2526headlineid%253D1%2526desclayoutid%253D10%2526desclayoutvn%253D1&ei=_P44V_2gOOe0e8eAAQ&usg=AFQjCNGRAmlr_odJoxfeYhACKyJHDhjOUA", "ga_language": "en-us", "gtm_container_id": "GTM-NLR27V", "os_family": "Windows 7", "ga_viewport_size": "1008x631", "browser_family": "IE"}' --partition-key testpartitionkey
