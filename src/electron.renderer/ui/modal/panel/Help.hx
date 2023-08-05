package ui.modal.panel;

class Help extends ui.modal.Panel {
	public function new() {
		super();

		// Main page
		linkToButton("button.showHelp");
		loadTemplate( "help", "helpPanel", {
			appUrl: Const.HOME_URL,
			discordUrl: Const.DISCORD_URL,
			docsUrl: Const.DOCUMENTATION_URL,
			jsonUrl: Const.JSON_DOC_URL,
			app: Const.APP_NAME,
			ver: Const.getAppVersion(),
		});

		jContent.find(".changelog").click( _->{
			new ui.modal.dialog.Changelog(false);
			close();
		});

		// Key icons
		jContent.find("dt").each( function(idx, e) {
			var jDt = new J(e);
			JsTools.parseKeysIn( jDt );
		});

		// Videos
		var jYouTubeTags = jContent.find("youtube");
		jYouTubeTags.each( (idx,e)->{
			var jInfos = new J(e);
			var jVideo = new J('<a/>');
			jVideo.insertAfter(jInfos);

			var id = jInfos.attr("id");
			var desc = jInfos.attr("desc");
			jVideo.attr("href", 'https://youtu.be/$id');
			jVideo.attr("title", desc);
			jVideo.append('<img src="https://img.youtube.com/vi/$id/0.jpg" alt="$desc"/>');
		});
		jYouTubeTags.remove();
		JsTools.parseComponents( jContent.find(".videos") );
	}

}
