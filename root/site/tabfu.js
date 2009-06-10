	Ext.ns('Baseliner');

	Baseliner.addNewTabDiv = function( div, ptitle){
			var tab = Ext.getCmp('main-panel').add( div );
			Ext.getCmp('main-panel').setActiveTab(tab); 
	};
	//adds a new object to a tab 
	Baseliner.addNewTabItem = function( comp, title ) {
		var tabpanel = Ext.getCmp('main-panel');
		var tab = tabpanel.add(comp);
		tab.setTitle( title );
		tabpanel.setActiveTab(comp);
	};
	//adds a new fragment component with html or <script>...</script>
	Baseliner.addNewTab = function(purl, ptitle){
			var tab = Ext.getCmp('main-panel').add({ 
					xtype: 'panel', 
					layout: 'fit', 
					autoLoad: {url: purl, scripts:true }, 
					title: ptitle
			}); 
			Ext.getCmp('main-panel').setActiveTab(tab); 
	};
	Baseliner.runUrl = function(url) {
		Ext.get('run-panel').load({ url: url, scripts:true }); 
	};
	//adds a new tab from a function() type component
	Baseliner.addNewTabComp = function( comp_url, ptitle ){
		Ext.Ajax.request({
			url: comp_url,
			success: function(xhr) {
				try {
					var comp = eval(xhr.responseText);
					Baseliner.addNewTabItem( comp, ptitle );
				} catch(err) {
					if( xhr.responseText.indexOf('dhandler') ) {
						Ext.Msg.alert("Page not found: ", comp_url );
					} else {
						Ext.Msg.alert("Error Rendering Component", err);
					}
				}
			},
			failure: function(xhr) {
				var win = new Ext.Window({ layout: 'fit', 
					autoScroll: true, title: ptitle+' create failed', 
					height: 600, width: 600, 
					html: 'Server communication failure:' + xhr.responseText });
				win.show();
			}
		});
	};
	Baseliner.formSubmit = function( form ) {
			form.submit({
				success: function(f,a){ Ext.Msg.alert('Success', 'Form submitted ok.'); },
				failure: function(f,a){ Ext.Msg.alert('Warning', 'Error submitting form.' + a); }
			});
	};
	Baseliner.templateLoader = function(){
		var that = {};
		var map = {};
		that.getTemplate = function(url, callback) {
			if (map[url] === undefined) {
				Ext.Ajax.request({
					url: url,
					success: function(xhr){
						var template = new Ext.XTemplate(xhr.responseText);
						template.compile();
						map[url] = template;
						callback(template);
					}
				});
			} else {
				callback(map[url]);
			}
		};
	 
		return that;
	};

	Baseliner.showAjaxComp = function(purl,pparams){
		Ext.Ajax.request({
			url: purl,
			params: pparams,
			success: function(xhr) {
				try {
					comp = eval(xhr.responseText);
					comp.show();
				} catch(err) {
					Ext.Msg.alert("Error Rendering Component", err);
				}
			},
			failure: function(xhr) {
				var win = new Ext.Window({ layout: 'fit', 
					id: 'cal-win',
					autoScroll: true, title: ptitle+' create failed', 
					height: 600, width: 600, 
					html: 'Server communication failure:' + xhr.responseText });
				win.show();
			}
		});
	};

