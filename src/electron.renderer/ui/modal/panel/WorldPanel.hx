package ui.modal.panel;

class WorldPanel extends ui.modal.Panel {
	var levelInstanceForm : ui.LevelInstanceForm;

	public function new() {
		super();

		linkToButton("button.world");
		jMask.hide();
		loadTemplate("worldPanel");

		// Current level instance form
		levelInstanceForm = new ui.LevelInstanceForm();
		jContent.find(".currentLevelInstance").append( levelInstanceForm.jWrapper );
		levelInstanceForm.useLevel(editor.curLevel);

		updateWorldForm();

		if( editor.gifMode )
			jModalAndMask.hide();
	}


	override function onDispose() {
		super.onDispose();
		levelInstanceForm.dispose();
		levelInstanceForm = null;
	}

	override function onGlobalEvent(ge:GlobalEvent) {
		super.onGlobalEvent(ge);

		switch ge {
			case WorldSettingsChanged:
				updateWorldForm();

			case ProjectSelected:
				updateWorldForm();

			case _:
		}

		if( levelInstanceForm!=null && !isClosing() )
			levelInstanceForm.onGlobalEvent(ge);
	}


	function updateWorldForm() {
		var jForm = jContent.find(".worldSettings dl.form");
		jForm.find("*").off();

		for(k in ldtk.Json.WorldLayout.getConstructors())
			jForm.removeClass("layout-"+k);
		jForm.addClass("layout-"+curWorld.worldLayout.getName());

		// World layout
		var old = curWorld.worldLayout;
		var e = new form.input.EnumSelect(
			jForm.find("[name=worldLayout]"),
			ldtk.Json.WorldLayout,
			()->curWorld.worldLayout,
			(l)->curWorld.worldLayout = l,
			(l)->switch l {
				case Free: L.t._("2D自由地图-在世界中自由定位");
				case GridVania: L.t._("GridVania-关卡左上角对齐世界网格");
				case LinearHorizontal: L.t._("水平 - 一个关卡接一个关卡");
				case LinearVertical: L.t._("垂直 - 一个关卡接一个关卡");
			}
		);

		if( project.countAllLevels() > 2 )
			e.customConfirm = (oldV,newV)->L.t._("更改此位置将更改所有级别位置！请确保您知道自己在做什么:)");
		e.onBeforeSetter = ()->{
			new LastChance(L.t._("世界布局已更改"), editor.project);
		}
		e.onValueChange = (l)->{
			curWorld.onWorldLayoutChange(old);
			curWorld.reorganizeWorld();
		}
		e.linkEvent( WorldSettingsChanged );

		// Default new level size
		var i = Input.linkToHtmlInput( curWorld.defaultLevelWidth, jForm.find("#defaultLevelWidth"));
		i.linkEvent(WorldSettingsChanged);
		i.setBounds(project.defaultGridSize, 9999);
		i.fixValue = v->curWorld.snapWorldGridX(v,true);
		var i = Input.linkToHtmlInput( curWorld.defaultLevelHeight, jForm.find("#defaultLevelHeight"));
		i.linkEvent(WorldSettingsChanged);
		i.setBounds(project.defaultGridSize, 9999);
		i.fixValue = v->curWorld.snapWorldGridY(v,true);

		// World grid
		var oldW = curWorld.worldGridWidth;
		var i = Input.linkToHtmlInput( curWorld.worldGridWidth, jForm.find("[name=worldGridWidth]"));
		i.linkEvent(WorldSettingsChanged);
		i.onChange = ()->curWorld.onWorldGridChange(oldW, curWorld.worldGridHeight);

		var oldH = curWorld.worldGridHeight;
		var i = Input.linkToHtmlInput( curWorld.worldGridHeight, jForm.find("[name=worldGridHeight]"));
		i.linkEvent(WorldSettingsChanged);
		i.onChange = ()->curWorld.onWorldGridChange(curWorld.worldGridWidth, oldH);

		JsTools.parseComponents(jForm);
		checkBackup();
	}


	override function onClose() {
		super.onClose();
		editor.setWorldMode(false);
	}

	override function update() {
		super.update();
		if( !editor.worldMode )
			close();
	}
}