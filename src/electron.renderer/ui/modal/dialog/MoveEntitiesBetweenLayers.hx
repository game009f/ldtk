package ui.modal.dialog;

class MoveEntitiesBetweenLayers extends ui.modal.Dialog {
	var fromLd : data.def.LayerDef;
	public function new(fromLayerDef:data.def.LayerDef) {
		super();
		fromLd = fromLayerDef;
		loadTemplate("moveEntitiesBetweenLayers");

		var jForm = jContent.find("dl.form");
		var jConfirm = jContent.find(".confirm");


		// Target select
		var jTargetSel = jForm.find("select[name=target]");
		jTargetSel.addClass("required");
		jTargetSel.change( _->{
			var raw = jTargetSel.val();
			if( raw=="" )
				jTargetSel.addClass("required");
			else
				jTargetSel.removeClass("required");
			var jPrefix = jTargetSel.prevAll(".targetPrefix");
			switch raw.split(".")[0] {
				case "id": jPrefix.text("of");
				case "tag": jPrefix.text("with tag");
				case _: jPrefix.text("...");
			}
		});

		// All entity identifiers
		var jOptGroup = jTargetSel.find("optGroup.allIds");
		jOptGroup.empty();
		for(ed in project.defs.entities)
			jOptGroup.append('<option value="id.${ed.identifier}">${ed.identifier}</option>');
		// All entity tags
		var jOptGroup = jTargetSel.find("optGroup.allTags");
		jOptGroup.empty();
		for(t in project.defs.getAllTagsFrom(project.defs.entities, ed->ed.tags))
			jOptGroup.append('<option value="tag.$t">"$t"</option>');


		// Layer select
		var jLayerSel= jForm.find("select[name=layer]");
		jLayerSel.addClass("required");
		jLayerSel.change( _->{
			var raw = jLayerSel.val();
			if( raw=="" )
				jLayerSel.addClass("required");
			else
				jLayerSel.removeClass("required");
			jLayerSel.blur();
		});
		jLayerSel.find("option:not(:first)");
		for(ld in project.defs.layers) {
			var jOpt = new J('<option value="${ld.uid}">${ld.identifier}</option>');
			jLayerSel.append(jOpt);
			if( ld.type!=Entities ) {
				jOpt.append(" (not an Entities layer)");
				jOpt.prop("disabled",true);
			}
			if( ld.uid==fromLd.uid ) {
				jOpt.append(" (same as origin)");
				jOpt.prop("disabled",true);
			}
		}

		// Confirm
		jConfirm.click( _->{
			var filter = jTargetSel.val();
			var targetUid = Std.parseInt( jLayerSel.val() );

			// Check form
			if( filter=="" || !M.isValidNumber(targetUid) ) {
				N.error("请先提供所要求的资料.");
				return;
			}

			var targetLd : data.def.LayerDef = project.defs.getLayerDef(targetUid);
			var filterType : String = filter.split(".")[0];
			var filterId : String = filter.split(".")[1];

			// Check destination tags
			switch filterType {
				case "all":

				case "id":
					var ed = project.defs.getEntityDef(filterId);
					if( !targetLd.excludedTags.isEmpty() && ed.tags.hasAnyTagFoundIn(targetLd.excludedTags) ) {
						N.error("目标图层 "+targetLd.identifier+" 不接受具有这些标记之一的实体: "+targetLd.excludedTags.toArray());
						return;
					}
					if( !targetLd.requiredTags.isEmpty() && !ed.tags.hasAnyTagFoundIn(targetLd.requiredTags) ) {
						N.error("目标图层 "+targetLd.identifier+" 仅接受具有这些标记之一的实体: "+targetLd.requiredTags.toArray());
						return;
					}
			}

			new LastChance(L.t._("在图层之间移动的实体"), project);

			// Move all existing entities
			var n = 0;
			for(w in project.worlds)
			for(l in w.levels)
			for(fromLi in l.layerInstances) {
				if( fromLi.layerDefUid!=fromLd.uid)
					continue;

				var targetLi = l.getLayerInstance(targetLd);

				var movedEis = fromLi.entityInstances.filter( ei->{
					switch filterType {
						case "all":
							( targetLd.excludedTags.isEmpty() || !ei.def.tags.hasAnyTagFoundIn(targetLd.excludedTags) )
							&& ( targetLd.requiredTags.isEmpty() || ei.def.tags.hasAnyTagFoundIn(targetLd.requiredTags) );
						case "id": ei.def.identifier==filterId;
						case "tag": ei.def.tags.has(filterId);
						case _: false;
					}
				});

				for(ei in movedEis) {
					fromLi.entityInstances.remove(ei);
					targetLi.entityInstances.push(ei);
					ei.tidy(project,targetLi); // fix internal ei._li pointer
				}
				n+=movedEis.length;

				if( movedEis.length>0 ) {
					editor.invalidateLevelCache(l);
					editor.ge.emitAtTheEndOfFrame( LayerInstanceChangedGlobally(fromLi) );
					editor.ge.emitAtTheEndOfFrame( LayerInstanceChangedGlobally(targetLi) );
				}
			}

			new Message(
				L.t._("::n:: 实体已从 ::fromLayer:: 到 ::toLayer::.",  {
					n: n,
					fromLayer: fromLd.identifier,
					toLayer: targetLd.identifier,
				})
			);
		} );

		// Cancel
		jContent.find(".cancel").click( _->close() );
	}
}