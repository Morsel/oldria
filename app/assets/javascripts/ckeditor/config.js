CKEDITOR.editorConfig = function( config )
{
    config.uiColor = '#E2E2E2';
    config.toolbar_Basic = [
        ['Undo', 'Redo'],
        ['Bold', 'Italic'],
        ['Link','Unlink'],
        ['RemoveFormat'],
        ['Source']
    ];

    config.toolbar_Full = [
        ['Styles'],
        ['Undo', 'Redo'],
        ['Bold', 'Italic', '-', 'NumberedList', 'BulletedList'],
        ['Find','RemoveFormat'],
        ['Link', 'Unlink', 'Anchor'],
        ['Image','Embed','Attachment'],
        ['Source']
    ];

    config.PreserveSessionOnFileBrowser = true;
    config.language = 'en';
    config.format_tags = 'p;h2;h3;h4;h5;pre';

    config.forcePasteAsPlainText = true;
    config.toolbar = 'Basic';
    config.resize_maxWidth = 933;
    config.resize_minWidth = 639;
    
    config.stylesCombo_stylesSet = 'riastyles:/javascripts/ckeditor/styles.js';

    config.extraPlugins = "embed,attachment";
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


