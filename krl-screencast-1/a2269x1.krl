ruleset a2269x1 {
	meta {
		name "Hello World KRL Screencast #1"
		description <<
			
		>>
		author "Alex Olson"
		logging off
	}

	dispatch {
	}

	global {
        css <<
            .my-bacon-annotation {
                display: inline-block;
                color: #8b0000;
                border-radius: 4px;
                background-color: #eeeeee;
                transition: all 1s ease-in-out;
                padding: 5px;
                position: relative;
                z-index: 999999;
            }
            
            .my-bacon-annotation:hover {
                color: #eeeeee;
                background-color: #8b0000;
                border-radius: 8px;
                -webkit-transform: rotate(360deg) scale(2);
            }
            
            .my-bacon-annotation.no-bacon {
                color: #fa8072;
                background-color: #eeeeee;
            }
            
            .my-bacon-annotation.no-bacon:hover {
                color: #eeeeee;
                background-color: #fa8072;
                -webkit-transform: rotate(720deg) scale(2) translate(250px);
            }
        >>;
	}

	rule hello_world {
		select when web pageview url re/https?:\/\/(?:\w+?\.)?(.*?\.\w{2,4})\// setting (our_domain)
		pre {
            message = <<
                You are on #{our_domain}
            >>;
		}
		notify("Hello World", "This is a sample rule." + message) 
            with sticky = true;
	}
    
    rule bacon_decoration {
        select when pageview re/google|yahoo|bing/
        {
            emit <<
                function is_about_bacon(search_result) {
                    var result_domain = $K(".f cite", search_result).text();
                    var result_url = $K(".r a", search_result).attr("href").replace(/.*url=(.*?)(?:&|$)/, "$1");
                    
                    // console.log(result_domain);
                    // console.log(result_url);
                    
                    if (result_domain.match(/bacon/)) {
                        return "<span class = 'my-bacon-annotation'>Bacon is soooooo good!!!! Yum!</span>";
                    } else if (result_url.match(/bacon/)) {
                        return "<span class = 'my-bacon-annotation no-bacon'>bacon is so good! You should really consider buying a domain with bacon in it.</span>";
                    } else {
                        return false;
                    }
                }
            >>;
            
            annotate_search_results(is_about_bacon);
        }
    }
}
