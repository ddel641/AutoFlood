-- Version : French ( by @project-author@ )
-- Last Update : 22/05/2006

if (GetLocale() == "frFR") then
	MULTIFLOOD_LOAD = "MultiFlood VERSION chargé. Tapez /floodhelp pour obtenir de l'aide."

	MULTIFLOOD_STATS = "\"MESSAGE\" est envoyé toutes les RATE secondes dans le canal /CHANNEL."

	MULTIFLOOD_MESSAGE = "Le message est maintenant \"MESSAGE\"."
	MULTIFLOOD_RATE = "Le message est envoyé toutes les RATE secondes."
	MULTIFLOOD_CHANNEL = "Le message est envoyé dans le canal /CHANNEL."

	MULTIFLOOD_ACTIVE = "MultiFlood est activé."
	MULTIFLOOD_INACTIVE = "MultiFlood est désactivé."

	MULTIFLOOD_ERR_CHAN = "Le canal /CHANNEL est invalide."
	MULTIFLOOD_ERR_RATE = "Vous ne pouvez pas envoyer de messages à moins de RATE secondes d'intervalle."

	MULTIFLOOD_HELP = {
		"===================== Auto Flood =====================",
		"/mflood [on|off] : Démarre / arrête l'envoi du message.",
		"/mfloodmsg <message> : Définit le message à envoyer.",
		"/mfloodchan <canal> : Définit le canal à utiliser pour l'envoi.",
		"/mfloodrate <durée> : Définit la période (en secondes) d'envoi du message.",
		"/mfloodinfo : Affiche les paramètres.",
		"/mfloodhelp : Affiche ce message d'aide.",
	}
end
