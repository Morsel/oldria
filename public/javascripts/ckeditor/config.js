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
