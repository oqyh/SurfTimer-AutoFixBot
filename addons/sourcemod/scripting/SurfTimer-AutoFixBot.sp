#include <sourcemod>
#include <multicolors>

Handle timer1;

ConVar h_eplugin;
ConVar h_notify;
ConVar f_timer;

bool h_beplugin = false;
bool h_bnotify = false;
float f_ftimer = 0.0;

public Plugin myinfo =
{
    name = "Surftimer Auto Bot Fixer",
    author = "Gold KingZ",
    description = "Reload Bots Beginning Of Map",
    version = "1.0.0",
    url = "https://github.com/oqyh"
}

public void OnPluginStart()
{
	LoadTranslations( "SurfTimer-AutoFixBot.phrases" );
	
	h_eplugin = CreateConVar("sm_bot_fix_enable", "1", "Enable Auto Fix Bot Plugin || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	h_notify = CreateConVar("sm_bot_fix_notify", "1", "Enable Print Notification Chat Bot Fixed  || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	f_timer = CreateConVar("sm_bot_fix_timer", "50.0", "(in sec) Timer To Fix Bots Beginning Of The Map");
	
	HookConVarChange(h_eplugin, OnSettingsChanged);
	HookConVarChange(h_notify, OnSettingsChanged);
	HookConVarChange(f_timer, OnSettingsChanged);
	
	AutoExecConfig(true, "SurfTimer-AutoFixBot");
}

public void OnConfigsExecuted()
{
	h_beplugin = GetConVarBool(h_eplugin);
	h_bnotify = GetConVarBool(h_notify);
	f_ftimer = GetConVarFloat(f_timer);
}

public int OnSettingsChanged(Handle convar, const char[] oldValue, const char[] newValue)
{
	if(convar == h_eplugin)
	{
		h_beplugin = h_eplugin.BoolValue;
	}
	
	if(convar == h_notify)
	{
		h_bnotify = h_notify.BoolValue;
	}
	
	if(convar == f_timer)
	{
		f_ftimer = f_timer.FloatValue;
	}
	
	return 0;
}

public void OnMapStart()
{
	if(timer1 != null)
    {
        delete timer1;
    }
	
	if(h_beplugin)
	{
		timer1 = CreateTimer(f_ftimer, RezSay0);
	}
	
}

public Action RezSay0(Handle timer)
{
	timer1 = null;
	
	CreateTimer(1.0, RezSay2, _, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(3.0, RezSay1, _, TIMER_FLAG_NO_MAPCHANGE);
	
	CreateTimer(5.0, FixBot_Off, _, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(10.0, FixBot_On, _, TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Handled;
}

public Action RezSay2(Handle timer)
{
	if(h_bnotify)
	{
		CPrintToChatAll(" %t %t", "Prefix", "3");
	}
	return Plugin_Handled;
}

public Action RezSay1(Handle timer)
{
	if(h_bnotify)
	{
		CPrintToChatAll(" %t %t", "Prefix", "2");
	}
	return Plugin_Handled;
}

public Action FixBot_Off(Handle timer)
{
	ServerCommand("ck_replay_bot 0");
	ServerCommand("ck_bonus_bot 0");
	ServerCommand("ck_wrcp_bot 0");
	if(h_bnotify)
	{
		CPrintToChatAll(" %t %t", "Prefix", "1");
	}
	return Plugin_Handled;
}

public Action FixBot_On(Handle timer)
{
	ServerCommand("ck_replay_bot 1");
	ServerCommand("ck_bonus_bot 1");
	ServerCommand("ck_wrcp_bot 1");
	if(h_bnotify)
	{
		CPrintToChatAll(" %t %t", "Prefix", "done");
	}
	delete timer1;
	return Plugin_Handled;
}

