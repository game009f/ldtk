package page;

import hxd.Key;

class Home extends Page {
	public static var ME : Home;

	public function new() {
		super();

		ME = this;
		var changeLog = Const.getChangeLog();
		loadPageTemplate("home", {
			app: Const.APP_NAME,
			appVer: Const.getAppVersion(),
			buildDate: dn.MacroTools.getHumanBuildDate(),
			latestVer: changeLog.latest.version,
			latestDesc: changeLog.latest.title==null ? L.t._("发行说明") : '"'+changeLog.latest.title+'"',
			deepnightUrl: Const.DEEPNIGHT_DOMAIN,
			discordUrl: Const.DISCORD_URL,
			docUrl: Const.DOCUMENTATION_URL,
			websiteUrl : Const.HOME_URL,
			issueUrl : Const.ISSUES_URL,
			jsonUrl: Const.JSON_DOC_URL,
			email: Const.getContactEmail(),
		});
		App.ME.setWindowTitle();

		jPage.find(".changelogs code").each( function(idx,e) {
			var jCode = new J(e);
			if( (~/sample/i).match( jCode.text().toLowerCase() ) ) {
				var jLink = new J('<a href="#" class="discreet">${jCode.text()}</a>');
				jLink.click( function(ev:js.jquery.Event) {
					ev.preventDefault();
					onLoadSamples();
				});
				jCode.replaceWith(jLink);
			}
		});

		// Buttons
		jPage.find(".load").click( (_)->onLoad() );
		jPage.find(".samples").click( (_)->{
			if( settings.getUiStateBool(HideSamplesOnHome) )
				showSamples();
			else
				hideSamples();
		});
		jPage.find(".allSamples .hide").click( (_)->hideSamples() );
		jPage.find(".import").click( (ev)->onImport(ev) );
		jPage.find(".new").click( (_)->if( !cd.hasSetS("newLock",0.2) ) onNew() );

		if( !settings.getUiStateBool(HideSamplesOnHome) )
			showSamples(false);

		jPage.find(".buy").click( (ev)->{
			var w = new ui.Modal();
			w.loadTemplate("buy", {
				app: Const.APP_NAME,
				itchUrl: Const.ITCH_IO_BUY_URL,
				gitHubSponsorUrl: Const.GITHUB_SPONSOR_URL,
			});
			w.jContent.find("[data-link]").click((ev:js.jquery.Event)->{
				var jButton = ev.getThis();
				var url = jButton.attr("data-link");
				electron.Shell.openExternal(url);
			});
		});

		jPage.find("button.update").click((_)->{
			new ui.modal.dialog.Changelog();
		});

		jPage.find("button.settings").click( function(ev) {
			new ui.modal.dialog.EditAppSettings();
		});

		jPage.find("button.exit").click( function(ev) {
			App.ME.exit();
		});

		updateRecents();
		if( settings.v.lastProject!=null ) {
			settings.v.lastProject = null;
			settings.save();
		}

		// Samples
		var path = JsTools.getSamplesDir();
		App.LOG.debug("samplesDir="+path);
		var files = NT.readDir(path);
		var jSamples = jPage.find(".allSamples");
		var jScroller = jSamples.children(".scroller");
		jScroller.on( "wheel", (ev:js.html.WheelEvent)->{
			var ev = (cast ev).originalEvent;
			jScroller.scrollLeft( jScroller.scrollLeft() + ev.deltaY );
			ev.preventDefault();
		});
		for(f in files) {
			var fp = dn.FilePath.fromFile(path+"/"+f);
			if( fp.extension!="ldtk" )
				continue;

			var jSample = new J('<div class="sample"/>');
			jSample.appendTo(jScroller);
			jSample.append('<div class="thumb" style="background-image:url($path/thumbs/${fp.fileName}.png)"></div>');
			var name = StringTools.replace( fp.fileName, "_", " " );
			jSample.append('<div class="name">$name</div>');
			jSample.click(_->{
				App.ME.loadProject( fp.full );
			});

			if( App.ME.recentProjectsContains(fp.full) )
				jSample.addClass("seen");
		}
	}


	function updateRecents() : Void {
		ui.Tip.clear();
		var uniqueColorMix = 0x6066d3;

		// Clean up invalid paths
		settings.v.recentProjects = settings.v.recentProjects.filter( (p)->{
			if( p==null || p.length==0 )
				return false;

			var fp = dn.FilePath.fromFile(p);
			return fp!=null && fp.directory!=null && fp.fileWithExt!=null;
		});
		settings.v.recentDirs = settings.v.recentDirs.filter( (p)->{
			if( p==null || p.length==0 )
				return false;

			var fp = dn.FilePath.fromDir(p);
			return fp!=null && fp.directory!=null;
		});
		settings.save();



		var recents = settings.v.recentProjects.copy();


		// Automatically detect backups
		var i = 0;
		while( i<recents.length ) {
			var fp = dn.FilePath.fromFile(recents[i]);
			var backup = fp.clone();
			backup.fileName+=Const.BACKUP_NAME_SUFFIX;
			if( !App.ME.recentProjectsContains(backup.full) && NT.fileExists(backup.full) )
				recents.insert(i+1, backup.full);
			i++;
		}



		// Trim common path parts
		var trimmedPaths = recents.copy();

		// List drive letters
		var driveLetters = new Map();
		for(path in trimmedPaths ) {
			var d = dn.FilePath.fromFile(path).getDriveLetter();
			driveLetters.set(d,d);
		}

		// Trim paths beginnings, grouped by drive
		var splitPaths = trimmedPaths.map( function(p) return dn.FilePath.fromFile(p).getDirectoryAndFileArray() );
		for(d in driveLetters) {
			// List path indexes in original array
			var sameDriveIndexes = [];
			for(i in 0...trimmedPaths.length)
				if( dn.FilePath.fromFile( trimmedPaths[i] ).getDriveLetter() == d )
					sameDriveIndexes.push(i);

			// Trim while beginning is the same
			var trimMore = true;
			var trim = 0;
			while( trimMore ) {
				var firstIdx = sameDriveIndexes[0];
				for( idx in sameDriveIndexes )
					if( trim>=splitPaths[idx].length-2 || splitPaths[idx][trim] != splitPaths[firstIdx][trim] ) {
						trimMore = false;
						break;
					}
				if( trimMore )
					trim++;
			}

			// Apply trimming to array
			while( trim>0 ) {
				for( idx in sameDriveIndexes )
					splitPaths[idx].shift();
				trim--;
			}
		}
		trimmedPaths = splitPaths.map( arr->arr.join("/") );



		// List files
		var jRecentFiles = jPage.find("ul.recentFiles");
		jRecentFiles.empty();
		if( recents.length>0 )
			jRecentFiles.append('<li class="title">Recent projects</li>');

		var i = recents.length-1;
		C.initUniqueColors(12, uniqueColorMix);
		while( i>=0 ) {
			var filePath = recents[i];
			var isBackupFile = filePath.indexOf( Const.BACKUP_NAME_SUFFIX )>=0;
			var li = new J('<li/>');

			try {
				var fp = dn.FilePath.fromFile(filePath);
				var col = C.pickUniqueColorFor( dn.FilePath.fromDir(trimmedPaths[i]).getDirectoryArray()[0] );
				if( App.ME.isInAppDir(filePath,true) )
					li.addClass("sample");

				var jName = new J('<span class="fileName">${fp.fileName}</span>');
				jName.appendTo(li);
				jName.css("color", C.intToHex( C.toWhite(col, 0.7) ));

				var jDir = JsTools.makePath(trimmedPaths[i], C.toWhite(col, 0.3));
				// var jDir = new J('<span class="dir">${trimmedPaths[i]}</span>');
				jDir.appendTo(li);
				// jDir.css("color", C.intToHex( C.toWhite(col, 0.3) ));

				li.click( function(ev) {
					App.ME.loadProject(filePath);
				});

				if( !NT.fileExists(filePath) )
					li.addClass("missing");

				if( isBackupFile )
					li.addClass("crash");

				// Backups button
				if( ui.ProjectSaver.hasBackupFiles(filePath) ) {
					var all = ui.ProjectSaver.listBackupFiles(filePath);
					if( all.length>0 ) {
						var jBackups = new J('<button class="backups gray"/>');
						jBackups.appendTo(li);
						jBackups.append('<span class="icon history"/>');
						jBackups.click( (ev:js.jquery.Event)->{
							ev.stopPropagation();
							// List all backup files
							var ctx = new ui.modal.ContextMenu(ev);
							var crashBackups = [];
							for( b in all ) {
								if( b.crash )
									crashBackups.push(b.backup);

								ctx.add({
									label: ui.ProjectSaver.isCrashFile(b.backup.full) ? Lang.t._("Crash recovery"): Lang.relativeDate(b.date),
									className: b.crash ? "crash" : null,
									sub: Lang.date(b.date),
									cb: ()->App.ME.loadProject(b.backup.full)
								});
							}

							if( crashBackups.length>0 )
								ctx.add({
									label: L.t._("删除所有崩溃恢复文件"),
									className: "warning",
									cb: ()->{
										new ui.modal.dialog.Confirm(
											L.t._("删除所有崩溃恢复文件项目 ::name::?", { name: fp.fileName}),
											true,
											()->{
												for(fp in crashBackups)
													NT.removeFile(fp.full);
												updateRecents();
											}
										);
									}
								});
						});
					}
				}

				var act : ui.modal.ContextMenu.ContextActions = [
					{
						label: L.t._("从此文件夹加载"),
						cb: onLoad.bind( dn.FilePath.fromFile(filePath).directory ),
					},
					{
						label: L.t._("查找文件"),
						cb: JsTools.locateFile.bind(filePath, true),
					},
					{
						label: L.t._("从历史记录中删除"),
						show: ()->!isBackupFile,
						cb: ()->{
							App.ME.unregisterRecentProject(filePath);
							updateRecents();
						}
					},
					{
						label: L._Delete(L.t._("备份文件")),
						show: ()->isBackupFile,
						cb: ()->{
							NT.removeFile(filePath);
							App.ME.unregisterRecentProject(filePath);
							updateRecents();
						}
					},
					{
						label: L.t._("清除所有历史记录"),
						cb: ()->{
							App.ME.clearRecentProjects();
							updateRecents();
						}
					},
				];
				ui.modal.ContextMenu.addTo(li, act );


				li.appendTo(jRecentFiles);
			}

			catch( e:Dynamic ) {
				App.LOG.error("Problem with recent file: "+filePath);
				li.remove();
			}


			i--;
		}


		// Trim common parts in dirs
		var dirs = settings.v.recentDirs.map( dir->dn.FilePath.fromDir(dir) );
		dirs.reverse();
		var trim = 0;
		var same = true;
		while( same && dirs.length>1 ) {
			for(i in 1...dirs.length) {
				if( dirs[0].full.charAt(trim) != dirs[i].full.charAt(trim) ) {
					same = false;
					break;
				}
			}
			if( same )
				trim++;
		}
		if( dirs.length==1 && dirs[0].directory!=null )
			trim = dirs[0].full.lastIndexOf( dirs[0].slash() )+1;


		// List dirs
		var jRecentDirs = jPage.find("ul.recentDirs");
		jRecentDirs.empty();
		if( dirs.length>0 )
			jRecentDirs.append('<li class="title">Recent folders</li>');
		C.initUniqueColors(12, uniqueColorMix);
		for(fp in dirs) {
			var li = new J('<li/>');
			try {

				if( !NT.fileExists(fp.directory) )
					li.addClass("missing");

				if( App.ME.isInAppDir(fp.full,true) )
					li.addClass("sample");

				var shortFp = dn.FilePath.fromDir( fp.directory.substr(trim) );
				var col = C.toWhite( C.pickUniqueColorFor( shortFp.getDirectoryArray()[0] ), 0.3 );
				li.append( JsTools.makePath( shortFp.full, col ) );
				li.click( (_)->{
					if( NT.fileExists(fp.directory) )
						onLoad(fp.directory);
					else {
						App.ME.unregisterRecentDir(fp.directory);

						// Try to open parent
						fp.removeLastDirectory();
						if( NT.fileExists(fp.directory) )
							onLoad(fp.directory);
						else
							N.error("已从历史记录中删除丢失的文件夹");

						updateRecents();
					}
				});

				ui.modal.ContextMenu.addTo(li, [
					{
						label: L.t._("查找文件夹"),
						cb: JsTools.locateFile.bind(fp.directory, false),
					},
					{
						label: L.t._("此文件夹中的新项目"),
						cb: onNew.bind(fp.directory),
					},
					{
						label: L.t._("从历史记录中删除"),
						cb: ()->{
							App.ME.unregisterRecentDir(fp.directory);
							updateRecents();
						}
					},
					{
						label: L.t._("清除所有文件夹历史记录"),
						cb: ()->{
							App.ME.clearRecentDirs();
							updateRecents();
						}
					},
				]);

				li.appendTo(jRecentDirs);

			}
			catch(e:Dynamic) {
				App.LOG.error("Problem with recent dir: "+fp.full);
				li.remove();
			}
		}

		JsTools.parseComponents(jRecentFiles);
	}


	public function onLoad(?openPath:String) {
		if( openPath==null )
			openPath = App.ME.getDefaultDialogDir();
		dn.js.ElectronDialogs.openFile(["."+Const.FILE_EXTENSION,".json"], openPath, function(filePath) {
			App.ME.loadProject(filePath);
		});
	}


	function onImport(ev:js.jquery.Event) {
		var ctx = new ui.modal.ContextMenu(ev);
		ctx.addTitle( L.t._("从其他应用导入项目") );
		ctx.positionNear( new J(ev.target) );
		ctx.add({
			label: L.t._("Ogmo 3 项目"),
			cb: ()->onImportOgmo(),
		});
	}

	function onImportOgmo() {
		var dir = App.ME.getDefaultDialogDir();

		#if debug
		dir = "C:/projects/LDtk/tests/ogmo"; // HACK remove this hard-coded path
		#end

		dn.js.ElectronDialogs.openFile([".ogmo"], dir, function(filePath) {
			var i = new importer.OgmoLoader(filePath);
			ui.modal.MetaProgress.start("Importing OGMO 3 project...", 3);
			delayer.addS( ()->{
				var p = i.load();
				i.log.printAllToLog(App.LOG);
				if( p!=null ) {
					ui.modal.MetaProgress.advance();
					new ui.ProjectSaver(this, p, (ok)->{
						ui.modal.MetaProgress.advance();
						N.success("成功!");
						App.ME.loadProject(p.filePath.full, (ok)->ui.modal.MetaProgress.completeCurrent());
					});
				}
				else {
					ui.modal.MetaProgress.closeCurrent();
					new ui.modal.dialog.LogPrint(i.log);
					new ui.modal.dialog.Message(L.t._("无法导入此 Ogmo 项目。如果您真的需要这个，请随时向我发送Ogmo项目文件，以便我可以检查并修复更新程序（请参阅联系链接）."));
				}
			}, 0.1);
		});
	}


	function showSamples(anim=true) {
		jPage.find(".files").addClass("hasSamples");
		if( anim )
			jPage.find(".allSamples").slideDown(100);
		else
			jPage.find(".allSamples").show();
		settings.setUiStateBool( HideSamplesOnHome, false );
	}


	function hideSamples() {
		jPage.find(".files").removeClass("hasSamples");
		jPage.find(".allSamples").slideUp(60);
		settings.setUiStateBool( HideSamplesOnHome, true );
	}


	public function onLoadSamples() {
		dn.js.ElectronDialogs.openFile(["."+Const.FILE_EXTENSION], JsTools.getSamplesDir(), function(filePath) {
			App.ME.loadProject(filePath);
		});
	}

	public function onNew(?openPath:String) {
		dn.js.ElectronDialogs.saveFileAs(["."+Const.FILE_EXTENSION], openPath!=null ? openPath : App.ME.getDefaultDialogDir(), function(filePath) {
			var fp = dn.FilePath.fromFile(filePath);
			fp.extension = "ldtk";

			var p = data.Project.createEmpty(fp.full);

			var data = ui.ProjectSaver.prepareProjectSavingData(p);
			new ui.ProjectSaver(this, p, (success)->{
				if( success ) {
					N.msg("New project created: "+p.filePath.full);
					App.ME.loadPage( ()->new Editor(p), true );
				}
				else {
					N.error("无法创建此项目文件!");
				}
			});
		});
	}


	override function onKeyPress(keyCode:Int) {
		super.onKeyPress(keyCode);

		if( App.ME.isLocked() )
			return;

		switch keyCode {
			case K.W, K.Q:
				if( App.ME.isCtrlDown() )
					App.ME.exit();

			case K.ENTER if( !ui.Modal.hasAnyOpen() ):
				jPage.find("ul.recentFiles li:not(.title):first").click();

			case K.ESCAPE:
				if( ui.Modal.hasAnyOpen() )
					ui.Modal.closeLatest();
				else if( jPage.find(".changelogsWrapper").hasClass("fullscreen") )
					jPage.find("button.fullscreen").click();

			// Open settings
			case K.F12 if( !App.ME.hasAnyToggleKeyDown() ):
				if( !ui.Modal.isOpen(ui.modal.dialog.EditAppSettings) )
					new ui.modal.dialog.EditAppSettings();
		}
	}

}
