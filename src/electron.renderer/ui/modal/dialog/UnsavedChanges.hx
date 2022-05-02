package ui.modal.dialog;

class UnsavedChanges extends ui.modal.Dialog {
	public function new(?target:js.jquery.JQuery, after:Void->Void, ?onCancel:Void->Void) {
		super(target, "unsavedChanges");

		jContent.text( L.t._("是否要在离开前保存?") );

		addButton(L.t._("是"), "save", ()->{
			close();
			Editor.ME.onSave(after);
		});
		addButton(L.t._("否"), ()->{
			close();
			after();
		});
		addCancel( onCancel );

		#if debug
		after();
		#end
	}
}