ConVar g_cvmsg_textcol;
char g_msg_textcol[32];
ConVar g_cvmsg_varcol;
char g_msg_varcol[32];
ConVar g_cvmsg_prefix;
char g_msg_prefix[32];
ConVar g_cvrcon_highlight;
char g_rcon_highlight[32];

ConVar g_cvSteamApiKey;
char g_sSteamApiKey[128];
ConVar g_cvDiscordBotToken;
char g_sDiscordBotToken[128];
ConVar g_cvDiscordWebhook;
char g_sDiscordWebhook[256];
ConVar g_cvRCONWebhook;
char g_sRCONWebhook[256];

ConVar g_cvDiscordServerId;
char g_sDiscordServerId[64];
ConVar g_cvChannelId;
char g_sChannelId[64];
ConVar g_cvRCONChannelId;
char g_sRCONChannelId[64];

ConVar g_cvServerToDiscord;
ConVar g_cvDiscordToServer;
ConVar g_cvServerToDiscordAvatars;
ConVar g_cvRCONDiscordToServer;
ConVar g_cvPrintRCONResponse;

ConVar g_cvServerMessage;
ConVar g_cvConnectMessage;
ConVar g_cvDisconnectMessage;
ConVar g_cvMapChangeMessage;
ConVar g_cvMessage;
ConVar g_cvHideCommands;
char g_sHideCommands[64];
ConVar g_cvShowServerTags;
ConVar g_cvShowServerName;
ConVar g_cvShowSteamID;
ConVar g_cvShowSteamID_Mode;
char g_sShowSteamID_Mode[32];

void SetupConvars() 
{
    AutoExecConfig_SetCreateFile(true);
    AutoExecConfig_SetFile("discordrelay");
    
    // Keys/Tokens
    g_cvSteamApiKey = AutoExecConfig_CreateConVar("discrelay_steamapikey", "", "Your Steam API key (needed for discrelay_servertodiscordavatars)");
    g_cvDiscordBotToken = AutoExecConfig_CreateConVar("discrelay_discordbottoken", "", "Your Discord bot key (needed for discrelay_discordtoserver)");
    g_cvDiscordWebhook = AutoExecConfig_CreateConVar("discrelay_discordwebhook", "", "Webhook for Discord channel (needed for discrelay_servertodiscord)");
    
    // IDs
    g_cvDiscordServerId = AutoExecConfig_CreateConVar("discrelay_discordserverid", "", "Discord Server Id, required for Discord to server");
    g_cvChannelId = AutoExecConfig_CreateConVar("discrelay_channelid", "", "Channel Id for Discord to server (This channel would be the one where the plugin check for messages to send to the server)");
    g_cvRCONChannelId = AutoExecConfig_CreateConVar("discrelay_rcon_channelid", "", "Channel ID where RCON commands should be sent");
    g_cvRCONWebhook = AutoExecConfig_CreateConVar("discrelay_rcon_webhook", "", "Webhook for RCON reponses, required for discrelay_rcon_printreponse");
    
    // Switches
    g_cvServerToDiscord = AutoExecConfig_CreateConVar("discrelay_servertodiscord", "1", "Enables messages sent in the server to be forwarded to discord");
    g_cvDiscordToServer = AutoExecConfig_CreateConVar("discrelay_discordtoserver", "1", "Enables messages sent in Discord to be forwarded to server (discrelay_discordtoserver and discrelay_discordbottoken need to be set)");
    g_cvServerToDiscordAvatars = AutoExecConfig_CreateConVar("discrelay_servertodiscordavatars", "1", "Changes webhook avatar to clients steam avatar (discrelay_servertodiscord needs to set to 1, and steamapi key needs to be set)");
    g_cvRCONDiscordToServer = AutoExecConfig_CreateConVar("discrelay_rcon_enabled", "0", "Enables RCON functionality");
    g_cvPrintRCONResponse = AutoExecConfig_CreateConVar("discrelay_rcon_printreponse", "1", "Prints reponse from command (discrelay_rcon_webhook required)");
    
    // Message Switches
    g_cvServerMessage = AutoExecConfig_CreateConVar("discrelay_servermessage", "1", "Prints server say commands to Discord (discrelay_servertodiscord needs to set to 1)");
    g_cvConnectMessage = AutoExecConfig_CreateConVar("discrelay_connectmessage", "1", "relays client connection to Discord (discrelay_servertodiscord needs to set to 1)");
    g_cvDisconnectMessage = AutoExecConfig_CreateConVar("discrelay_disconnectmessage", "1", "relays client disconnection messages to Discord (discrelay_servertodiscord needs to set to 1)");
    g_cvMapChangeMessage = AutoExecConfig_CreateConVar("discrelay_mapchangemessage", "1", "relays map changes to Discord (discrelay_servertodiscord needs to set to 1)");
    g_cvMessage = AutoExecConfig_CreateConVar("discrelay_message", "1", "relays client messages to Discord (discrelay_servertodiscord needs to set to 1)");
    g_cvHideCommands = AutoExecConfig_CreateConVar("discrelay_hidecommands", "!,/", "Hides any message that begins with the specified prefixes (e.g., '!'). Separate multiple prefixes with commas.");
    g_cvShowServerTags = AutoExecConfig_CreateConVar("discrelay_showservertags", "1", "Displays sv_tags in server status");
    g_cvShowServerName = AutoExecConfig_CreateConVar("discrelay_showservername", "1", "Displays hostname in server status");
    g_cvShowSteamID = AutoExecConfig_CreateConVar("discrelay_showsteamid", "0", "Displays a Player's Steam ID below every message");
    g_cvShowSteamID_Mode = AutoExecConfig_CreateConVar("discrelay_showsteamid_mode", "name", "Possible values: bottom, top, name, prepend, append");
    
    // Customization
    g_cvmsg_textcol = AutoExecConfig_CreateConVar("discrelay_msg_textcol", "{default}", "Color of Discord messages");
    g_cvmsg_varcol = AutoExecConfig_CreateConVar("discrelay_msg_varcol", "{gray}", "Color of Discord usernames");
    g_cvmsg_prefix = AutoExecConfig_CreateConVar("discrelay_msg_prefix", "*DISCORD*", "Prefix for Discord messages");
    g_cvrcon_highlight = AutoExecConfig_CreateConVar("discrelay_rcon_highlight", "dsconfig", "Syntax highlighting for RCON responses (see: https://highlightjs.org/demo)");

    
    AutoExecConfig_CleanFile();
    AutoExecConfig_ExecuteFile();
    
    g_cvSteamApiKey.GetString(g_sSteamApiKey, sizeof(g_sSteamApiKey));
    g_cvDiscordWebhook.GetString(g_sDiscordWebhook, sizeof(g_sDiscordWebhook));
    g_cvRCONWebhook.GetString(g_sRCONWebhook, sizeof(g_sRCONWebhook));
    
    g_cvDiscordServerId.GetString(g_sDiscordServerId, sizeof(g_sDiscordServerId));
    g_cvDiscordBotToken.GetString(g_sDiscordBotToken, sizeof(g_sDiscordBotToken));
    g_cvChannelId.GetString(g_sChannelId, sizeof(g_sChannelId));
    g_cvRCONChannelId.GetString(g_sRCONChannelId, sizeof(g_sRCONChannelId));
    g_cvShowSteamID_Mode.GetString(g_sShowSteamID_Mode, sizeof(g_sShowSteamID_Mode));
    
    g_cvmsg_textcol.GetString(g_msg_textcol, sizeof(g_msg_textcol));
    g_cvmsg_varcol.GetString(g_msg_varcol, sizeof(g_msg_varcol));
    g_cvmsg_prefix.GetString(g_msg_prefix, sizeof(g_msg_prefix));
    g_cvrcon_highlight.GetString(g_rcon_highlight, sizeof(g_rcon_highlight));
    g_cvHideCommands.GetString(g_sHideCommands, sizeof(g_sHideCommands));
    
    g_cvSteamApiKey.AddChangeHook(OnDiscordRelayCvarChanged);
    g_cvDiscordBotToken.AddChangeHook(OnDiscordRelayCvarChanged);
    g_cvDiscordWebhook.AddChangeHook(OnDiscordRelayCvarChanged);
    g_cvRCONWebhook.AddChangeHook(OnDiscordRelayCvarChanged);
    
    g_cvDiscordServerId.AddChangeHook(OnDiscordRelayCvarChanged);
    g_cvChannelId.AddChangeHook(OnDiscordRelayCvarChanged);
    g_cvRCONChannelId.AddChangeHook(OnDiscordRelayCvarChanged);
    g_cvShowSteamID_Mode.AddChangeHook(OnDiscordRelayCvarChanged);
    
    g_cvmsg_textcol.AddChangeHook(OnDiscordRelayCvarChanged);
    g_cvmsg_varcol.AddChangeHook(OnDiscordRelayCvarChanged);
    g_cvmsg_prefix.AddChangeHook(OnDiscordRelayCvarChanged);
    g_cvrcon_highlight.AddChangeHook(OnDiscordRelayCvarChanged);
    g_cvHideCommands.AddChangeHook(OnDiscordRelayCvarChanged);
}

public void OnDiscordRelayCvarChanged(ConVar convar, char[] oldValue, char[] newValue)
{
    g_cvSteamApiKey.GetString(g_sSteamApiKey, sizeof(g_sSteamApiKey));
    g_cvDiscordBotToken.GetString(g_sDiscordBotToken, sizeof(g_sDiscordBotToken));
    g_cvDiscordWebhook.GetString(g_sDiscordWebhook, sizeof(g_sDiscordWebhook));
    g_cvRCONWebhook.GetString(g_sRCONWebhook, sizeof(g_sRCONWebhook));
    g_cvDiscordServerId.GetString(g_sDiscordServerId, sizeof(g_sDiscordServerId));
    g_cvChannelId.GetString(g_sChannelId, sizeof(g_sChannelId));
    g_cvRCONChannelId.GetString(g_sRCONChannelId, sizeof(g_sRCONChannelId));
    g_cvmsg_textcol.GetString(g_msg_textcol, sizeof(g_msg_textcol));
    g_cvmsg_varcol.GetString(g_msg_varcol, sizeof(g_msg_varcol));
    g_cvmsg_prefix.GetString(g_msg_prefix, sizeof(g_msg_prefix));
    g_cvrcon_highlight.GetString(g_rcon_highlight, sizeof(g_rcon_highlight));
    g_cvShowSteamID_Mode.GetString(g_sShowSteamID_Mode, sizeof(g_sShowSteamID_Mode));
    g_cvHideCommands.GetString(g_sHideCommands, sizeof(g_sHideCommands));
}