package ui.modal.panel;

class EditProject extends ui.modal.Panel {

	var showAdvanced = false;
	var allAdvancedOptions = [
		ldtk.Json.ProjectFlag.MultiWorlds,
		ldtk.Json.ProjectFlag.PrependIndexToLevelFileNames,
		ldtk.Json.ProjectFlag.ExportPreCsvIntGridFormat,
		ldtk.Json.ProjectFlag.UseMultilinesType,
	];

	var levelNamePatternEditor : NamePatternEditor;
	var pngPatternEditor : ui.NamePatternEditor;

	public function new() {
		super();

		loadTemplate("editProject", "editProject", {
			app: Const.APP_NAME,
			ext: Const.FILE_EXTENSION,
		});
		linkToButton("button.editProject");

		showAdvanced = project.hasAnyFlag(allAdvancedOptions);

		var jSave = jContent.find("button.save").click( function(ev) {
			editor.onSave();
			if( project.isBackup() )
				close();
		});
		if( project.isBackup() )
			jSave.text(L.t._("还原此备份"));

		var jSaveAs = jContent.find("button.saveAs").click( function(ev) {
			editor.onSave(true);
		});
		if( project.isBackup() )
			jSaveAs.hide();


		var jRename = jContent.find("button.rename").click( function(ev) {
			new ui.modal.dialog.InputDialog(
				L.t._("输入新的项目文件名:"),
				project.filePath.fileName,
				project.filePath.extWithDot,
				(str)->{
					if( str==null || str.length==0 )
						return L.t._("无效的文件名");

					var clean = dn.FilePath.cleanUp(str, true);
					if( clean.length==0 )
						return L.t._("无效的文件名");

					if( project.filePath.fileName==str )
						return L.t._("输入新的项目文件名。");

					var newPath = project.filePath.directoryWithSlash + str + project.filePath.extWithDot;
					if( NT.fileExists(newPath) )
						return L.t._("此文件名已在使用中。");

					return null;
				},
				(str)->{
					return dn.FilePath.cleanUpFileName(str);
				},
				(fileName)->{
					// Rename project
					App.LOG.fileOp('Renaming project: ${project.filePath.fileName} -> $fileName');
					try {
						// Rename project file
						App.LOG.fileOp('  Renaming project file...');
						var oldProjectPath = project.filePath.full;
						var oldExtDir = project.getAbsExternalFilesDir();
						project.filePath.fileName = fileName;

						// Rename sub dir
						if( NT.fileExists(oldExtDir) ) {
							App.LOG.fileOp('  Renaming project sub dir...');
							NT.renameFile(oldExtDir, project.getAbsExternalFilesDir());
						}

						// Re-save project
						editor.invalidateAllLevelsCache();
						App.LOG.fileOp('  Saving project...');
						new ui.ProjectSaver(this, project, (success)->{
							// Remove old project file
							App.LOG.fileOp('  Deleting old project file...');
							NT.removeFile(oldProjectPath);
							App.ME.unregisterRecentProject(oldProjectPath);

							// Success!
							N.success("重命名项目!");
							editor.needSaving = false;
							editor.updateTitle();
							App.ME.registerRecentProject(editor.project.filePath.full);
							App.LOG.fileOp('  Done.');
						});
					}
				}
			);
		});
		if( project.isBackup() )
			jRename.hide();

		jContent.find("button.locate").click( function(ev) {
			JsTools.locateFile( project.filePath.full, true );
		});

		pngPatternEditor = new ui.NamePatternEditor(
			"png",
			project.getImageExportFilePattern(),
			[
				{ k:"world", name:"World name" },
				{ k:"level_name", name:"Level name" },
				{ k:"level_idx", name:"Level idx)" },
				{ k:"layer_name", name:"Layer name" },
				{ k:"layer_idx", name:"Layer idx" },
			],
			(pat)->{
				project.pngFilePattern = pat==project.getDefaultImageExportFilePattern() ? null : pat;
				editor.ge.emit(ProjectSettingsChanged);
			},
			()->{
				project.pngFilePattern = null;
				editor.ge.emit(ProjectSettingsChanged);
			}
		);
		jContent.find(".pngPatternEditor").empty().append( pngPatternEditor.jEditor );

		levelNamePatternEditor = new ui.NamePatternEditor(
			"levelId",
			project.levelNamePattern,
			[
				{ k:"world", name:"World ID" },
				{ k:"idx1", name:"Level_index(1)", desc:"Level index (starting at 1)" },
				{ k:"idx", name:"Level_index(0)", desc:"Level index (starting at 0)" },
				{ k:"x", name:"x", desc:"X coordinate of the level" },
				{ k:"y", name:"y", desc:"Y coordinate of the level" },
				{ k:"gx", name:"Grid_X", desc:"X grid coordinate of the level" },
				{ k:"gy", name:"Grid_Y", desc:"Y grid coordinate of the level" },
				{ k:"depth", name:"World depth", desc:"Level depth in the world" },
			],
			(pat)->{
				project.levelNamePattern = pat;
				editor.ge.emit(ProjectSettingsChanged);
				editor.invalidateAllLevelsCache();
				project.tidy();
			},
			()->{
				if( project.levelNamePattern!=data.Project.DEFAULT_LEVEL_NAME_PATTERN ) {
					project.levelNamePattern = data.Project.DEFAULT_LEVEL_NAME_PATTERN;
					editor.ge.emit(ProjectSettingsChanged);
					editor.invalidateAllLevelsCache();
					project.tidy();
					N.success("值重置.");
				}
			}
		);
		jContent.find(".levelNamePatternEditor").empty().append( levelNamePatternEditor.jEditor );

		updateProjectForm();
	}

	override function onGlobalEvent(ge:GlobalEvent) {
		super.onGlobalEvent(ge);
		switch( ge ) {
			case ProjectSettingsChanged:
				updateProjectForm();

			case ProjectSaved:
				updateProjectForm();

			case _:
		}
	}

	function recommendSaving() {
		if( !cd.hasSetS("saveReco",2) )
			N.warning(
				L.t._("项目文件设置已更改"),
				L.t._("应至少保存项目一次，以便此设置应用其效果。")
			);
	}

	function updateProjectForm() {
		ui.Tip.clear();
		var jForm = jContent.find("dl.form:first");
		jForm.off().find("*").off();

		// Simplified format adjustments
		if( project.simplifiedExport )
			jForm.find(".notSimplified").hide();
		else
			jForm.find(".notSimplified").show();

		// File extension
		var ext = project.filePath.extension;
		var usesAppDefault = ext==Const.FILE_EXTENSION;
		var i = Input.linkToHtmlInput( usesAppDefault, jForm.find("[name=useAppExtension]") );
		i.onValueChange = (v)->{
			var old = project.filePath.full;
			var fp = project.filePath.clone();
			fp.extension = v ? Const.FILE_EXTENSION : "json";
			if( NT.fileExists(old) && NT.renameFile(old, fp.full) ) {
				App.ME.renameRecentProject(old, fp.full);
				project.filePath.parseFilePath(fp.full);
				N.success(L.t._("将文件扩展名更改为 ::ext::", { ext:fp.extWithDot }));
			}
			else {
				N.error(L.t._("无法重命名项目文件！"));
			}
		}

		// Backups
		var i = Input.linkToHtmlInput( project.backupOnSave, jForm.find("#backup") );
		i.linkEvent(ProjectSettingsChanged);
		var jLocate = i.jInput.siblings(".locate").empty();
		if( project.backupOnSave )
			jLocate.append( JsTools.makeLocateLink(project.getAbsExternalFilesDir()+"/backups", false) );
		var jCount = jForm.find("#backupCount");
		jCount.val( Std.string(Const.DEFAULT_BACKUP_LIMIT) );
		if( project.backupOnSave ) {
			jCount.show();
			jCount.siblings("span").show();
			var i = Input.linkToHtmlInput( project.backupLimit, jCount );
			i.setBounds(3, 50);
		}
		else {
			jCount.hide();
			jCount.siblings("span").hide();
		}
		jForm.find(".backupRecommend").css("visibility", project.recommendsBackup() ? "visible" : "hidden");


		// Json minifiying
		var i = Input.linkToHtmlInput( project.minifyJson, jForm.find("[name=minify]") );
		i.linkEvent(ProjectSettingsChanged);
		i.onChange = ()->{
			editor.invalidateAllLevelsCache;
			recommendSaving();
		}

		// Simplified format
		var i = Input.linkToHtmlInput( project.simplifiedExport, jForm.find("[name=simplifiedExport]") );
		i.onChange = ()->{
			editor.invalidateAllLevelsCache();
			editor.ge.emit(ProjectSettingsChanged);
			if( project.simplifiedExport )
				recommendSaving();
		}
		var jLocate = jForm.find(".simplifiedExport .locate").empty();
		if( project.simplifiedExport )
			jLocate.append(
				NT.fileExists( project.getAbsExternalFilesDir() )
					? JsTools.makeLocateLink(project.getAbsExternalFilesDir()+"/simplified", false)
					: JsTools.makeLocateLink(project.filePath.full, true)
			);

		// External level files
		var i = Input.linkToHtmlInput( project.externalLevels, jForm.find("#externalLevels") );
		i.linkEvent(ProjectSettingsChanged);
		i.onValueChange = (v)->{
			editor.invalidateAllLevelsCache();
			recommendSaving();
		}
		var jLocate = jForm.find("#externalLevels").siblings(".locate").empty();
		if( project.externalLevels )
			jLocate.append( JsTools.makeLocateLink(project.getAbsExternalFilesDir(), false) );

		// Image export
		var jImgExport = jForm.find(".imageExportMode");
		var jSelect = jImgExport.find("select");
		var i = new form.input.EnumSelect(
			jSelect,
			ldtk.Json.ImageExportMode,
			()->project.imageExportMode,
			(v)->{
				project.pngFilePattern = null;
				project.imageExportMode = v;
				if( v!=None )
					recommendSaving();
			},
			(v)->switch v {
				case None: L.t._("不导出任何图像");
				case OneImagePerLayer: L.t._("每个关卡，为每个单独的层导出PNG");
				case OneImagePerLevel: L.t._("每个关卡，导出一个PNG（所有层向下合并）");
				case LayersAndLevels: L.t._("导出单独层和合并层");
			}
		);
		i.linkEvent(ProjectSettingsChanged);
		var jLocate = jImgExport.find(".locate").empty();
		pngPatternEditor.jEditor.hide();
		jForm.find(".imageExportOnly").hide();
		if( project.imageExportMode!=None && !project.simplifiedExport ) {
			jForm.find(".imageExportOnly").show();
			jLocate.append( JsTools.makeLocateLink(project.getAbsExternalFilesDir()+"/png", false) );

			pngPatternEditor.jEditor.show();
			pngPatternEditor.ofString( project.getImageExportFilePattern() );
		}


		// Identifier style
		var i = new form.input.EnumSelect(
			jForm.find("#identifierStyle"),
			ldtk.Json.IdentifierStyle,
			false,
			()->return project.identifierStyle,
			(v)->{
				if( v==project.identifierStyle )
					return;

				var old = project.identifierStyle;
				new LastChance(L.t._("标识符样式已更改"), project);
				project.identifierStyle = v;
				project.applyIdentifierStyleEverywhere(old);
				editor.invalidateAllLevelsCache();
				editor.ge.emit(ProjectSettingsChanged);
			},
			(v)->switch v {
				case Capitalize: L.t._('"My_identifier_1" -- 第一个字母总是大写的，其余的由你决定');
				case Uppercase: L.t._('"MY_IDENTIFIER_1" -- 全大写');
				case Lowercase: L.t._('"my_identifier_1" -- 全小写');
				case Free: L.t._('"my_IdEnTifIeR_1" -- 我不会更改您的字母大小写');
			}
		);
		i.customConfirm = (oldV,newV)->{
			switch newV {
				case Capitalize, Uppercase, Lowercase:
					L.t._("警告！\n请确保您使用的游戏引擎或导入程序支持此类 LDtk 标识符！\n如果继续，此项目中的所有标识符都将转换为新格式！\n确定吗？");

				case Free:
					L.t._("警告！\n请确保您使用的游戏引擎或导入程序支持此类 LDtk 标识符！\n您确定吗？");
			}
		}
		var jStyleWarning = jForm.find("#styleWarning");
		switch project.identifierStyle {
			case Capitalize, Uppercase: jStyleWarning.hide();
			case Lowercase, Free: jStyleWarning.show();
		}

		// Tiled export
		var i = Input.linkToHtmlInput( project.exportTiled, jForm.find("#tiled") );
		i.linkEvent(ProjectSettingsChanged);
		i.onValueChange = function(v) {
			if( v ) {
				new ui.modal.dialog.Message(
					Lang.t._("Disclaimer: Tiled export is only meant to load your LDtk project in a game framework that only supports Tiled files. It is recommended to write your own LDtk JSON parser, as some LDtk features may not be supported.\nIt's not so complicated, I promise :)"), "project",
					()->recommendSaving()
				);
			}
		}
		var jLocate = jForm.find("#tiled").siblings(".locate").empty();
		if( project.exportTiled )
			jLocate.append( JsTools.makeLocateLink(project.getAbsExternalFilesDir()+"/tiled", false) );

		// Level grid size
		var i = Input.linkToHtmlInput( project.defaultGridSize, jForm.find("[name=defaultGridSize]") );
		i.setBounds(1,Const.MAX_GRID_SIZE);
		i.linkEvent(ProjectSettingsChanged);

		// Workspace bg
		var i = Input.linkToHtmlInput( project.bgColor, jForm.find("[name=bgColor]"));
		i.linkEvent(ProjectSettingsChanged);

		// Level bg
		var i = Input.linkToHtmlInput( project.defaultLevelBgColor, jForm.find("[name=defaultLevelbgColor]"));
		i.linkEvent(ProjectSettingsChanged);

		// Default entity pivot
		var pivot = jForm.find(".pivot");
		pivot.empty();
		pivot.append( JsTools.createPivotEditor(
			project.defaultPivotX, project.defaultPivotY,
			0x0,
			function(x,y) {
				project.defaultPivotX = x;
				project.defaultPivotY = y;
				editor.ge.emit(ProjectSettingsChanged);
			}
		));

		// Level name pattern
		levelNamePatternEditor.ofString(project.levelNamePattern);

		// Advanced options
		var jAdvanceds = jForm.find(".adv");
		if( showAdvanced ) {
			jForm.find("a.showAdv").hide();
			jAdvanceds.addClass("visible");
		}
		else {
			jForm.find("a.showAdv").show().click(ev->{
				jAdvanceds.addClass("visible");
				showAdvanced = true;
				jWrapper.scrollTop( jWrapper.innerHeight() );
				ev.getThis().hide();
			});
		}
		var jAdvancedFlags = jAdvanceds.find("ul.advFlags");
		jAdvancedFlags.empty();
		for( flag in allAdvancedOptions ) {
			var jLi = new J('<li/>');
			jLi.appendTo(jAdvancedFlags);

			var jInput = new J('<input type="checkbox" id="$flag"/>');
			jInput.appendTo(jLi);

			var jLabel = new J('<label for="$flag"/>');
			jLabel.appendTo(jLi);
			var jDesc = new J('<div class="desc"/>');
			jDesc.appendTo(jLi);
			inline function _setDesc(str) {
				jDesc.html('<p>'+str.split("\n").join("</p><p>")+'</p>');
			}
			switch flag {
				case ExportPreCsvIntGridFormat:
					jLabel.text("Export legacy pre-CSV IntGrid layers data");
					_setDesc( L.t._("如果启用，导出的 JSON 文件还将包含现已弃用的数组 “intGrid”。该文件将明显变大。\n仅当您的游戏 API 仅支持 LDtk 0.8.x 或更低版本时，请使用此选项。") );

				case PrependIndexToLevelFileNames:
					jLabel.text("Prefix level file names with their index in array");
					_setDesc( L.t._("如果启用，则外部级别文件名将以反映其在内部阵列中位置的索引为前缀。\n不建议这样做，因为对于版本控制系统（如 GIT），插入新级别意味着重命名数组中所有后续级别的文件。\n此选项以前是默认行为，但在 1.0.0 版中已更改。") );

				case MultiWorlds:
					jLabel.text("Multi-worlds support");
					_setDesc( L.t._("如果启用，级别将存储在项目 JSON 根目录下的“worlds”数组中，而不是直接存储在根目录本身中。\n此选项仍处于实验阶段阶段，如果启用了“单独级别”选项，则尚不支持此选项。") );
					jInput.prop("disabled", project.worlds.length>1 );

				case UseMultilinesType:
					jLabel.text('Use "Multilines" instead of "String" for fields in JSON');
					_setDesc( L.t._("如果启用，则字段实例和字段定义的 JSON 值 “__type” 对于多行类型的所有字段，将改为 “Multilines”，而不是 “String”。") );

				case _:
			}

			var i = new form.input.BoolInput(
				jInput,
				()->project.hasFlag(flag),
				(v)->{
					editor.invalidateAllLevelsCache();
					project.setFlag(flag, v);
					editor.ge.emit(ProjectSettingsChanged);
				}
			);
		}

		// Sample description
		var i = new form.input.StringInput(
			jForm.find("[name=tutorialDesc]"),
			()->project.tutorialDesc,
			(v)->{
				v = dn.Lib.trimEmptyLines(v);
				if( v=="" )
					v = null;
				project.tutorialDesc = v;
				editor.ge.emit(ProjectSettingsChanged);
			}
		);

		JsTools.parseComponents(jForm);
		checkBackup();
	}
}
