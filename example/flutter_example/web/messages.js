const english=["Loading entrypoint...","Initializing Flutter...","We're almost there...",];const italian=["Caricamento dell'entrypoint...","Inizializzazione di Flutter...","Ci siamo quasi...",];function localizedMessage(index){var lang="";if(navigator.languages!=undefined){lang=navigator.languages[0]}else{lang=navigator.language}
if(lang.includes('it')){return italian[index]}
return english[index]}
