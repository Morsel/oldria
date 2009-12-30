CKEDITOR.editorConfig = function(config) {
config.uiColor = '#E2E2E2';
config.toolbar_Basic = [
		['Format'],
		['Undo', 'Redo'],
		['Bold', 'Italic', '-', 'NumberedList', 'BulletedList'],
		['Find','RemoveFormat'],
		['Link', 'Unlink', '-', 'Source']
	];

config.format_tags = 'p;h2;h3;h4;h5;pre';

config.forcePasteAsPlainText = true;
config.toolbar = 'Basic';
config.resize_maxWidth = 933;
config.resize_minWidth = 639;
};

// HTML writer properties
CKEDITOR.on( 'instanceReady', function(ev){
	var htmlWriter = ev.editor.dataProcessor.writer;
	var formattingDefaults = {
		indent : false,
		breakBeforeOpen : true,
		breakAfterOpen : false,
		breakBeforeClose : false,
		breakAfterClose : true
	};
	htmlWriter.indentationChars = "  ";
	htmlWriter.lineBreakChars = "\n\n";
	htmlWriter.setRules('p', formattingDefaults);
	htmlWriter.setRules('h2', formattingDefaults);
	htmlWriter.setRules('h3', formattingDefaults);
	htmlWriter.setRules('h4', formattingDefaults);
	htmlWriter.setRules('div', {
		indent : true,
		breakBeforeOpen : true,
		breakAfterOpen : true,
		breakBeforeClose : true,
		breakAfterClose : true
	});
});

