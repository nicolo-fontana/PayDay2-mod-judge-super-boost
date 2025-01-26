_G.JudgeSuperBoost = _G.JudgeSuperBoost or {}
JudgeSuperBoost._path = ModPath
JudgeSuperBoost._data_path = ModPath .. "jsb_saved_data.txt"
JudgeSuperBoost._data = {}




function JudgeSuperBoost:Save()
	local file = io.open( self._data_path, "w+" )
	if file then
		file:write( json.encode( self._data ) )
		file:close()
	end
end

function JudgeSuperBoost:Load()

	self._data["jsb_active_toggle_value"] = false;
	self._data["jsb_fire_mode_mutli_value"] = 1;

	self._data["jsb_damage_slider_value"] = 210;
	self._data["jsb_damage_mul_slider_value"] = 1;

	self._data["jsb_single_fire_rate_slider_value"] = 500;

	self._data["jsb_clip_ammo_slider_value"] = 5;
	self._data["jsb_clips_slider_value"] = 3;

	self._data["jsb_through_enemy_toggle_value"] = false;
	self._data["jsb_through_shield_toggle_value"] = false;
	self._data["jsb_through_wall_toggle_value"] = false;

	local file = io.open( self._data_path, "r" )
	if file then
		self._data = json.decode( file:read("*all") )
		file:close()
	end
end




-- Salva i valori iniziali di Judge in judgeBackup
function BackupJudgeParams(self, jb)
	jb["jsb_fire_mode_mutli_value"] = 1;

	jb["jsb_damage_slider_value"] = self.judge.stats.damage;
	jb["jsb_damage_mul_slider_value"] = 1;

	jb["jsb_single_fire_rate_slider_value"] = 500;
	
	jb["jsb_clip_ammo_slider_value"] = self.judge.CLIP_AMMO_MAX;
	jb["jsb_clips_slider_value"] = self.judge.NR_CLIPS_MAX;
end




-- Imposta i valori iniziali di judge (default / utente)
function SetInitialJudgeValues(self)
	if JudgeSuperBoost._data["jsb_active_toggle_value"] then
		SetJudgeFireMode(self, JudgeSuperBoost._data["jsb_fire_mode_mutli_value"]);

		self.judge.stats.damage = JudgeSuperBoost._data["jsb_damage_slider_value"];
		self.judge.stats_modifiers = {
			damage = JudgeSuperBoost._data["jsb_damage_mul_slider_value"]
		};

		self.judge.fire_mode_data = {
			fire_rate = 60 / JudgeSuperBoost._data["jsb_single_fire_rate_slider_value"]
		};

		self.judge.CLIP_AMMO_MAX = JudgeSuperBoost._data["jsb_clip_ammo_slider_value"];
		self.judge.NR_CLIPS_MAX = JudgeSuperBoost._data["jsb_clips_slider_value"];
		self.judge.AMMO_MAX = self.judge.CLIP_AMMO_MAX * self.judge.NR_CLIPS_MAX;

		self.judge.can_shoot_through_enemy = JudgeSuperBoost._data["jsb_through_enemy_toggle_value"];
		self.judge.can_shoot_through_shield = JudgeSuperBoost._data["jsb_through_shield_toggle_value"];
		self.judge.can_shoot_through_wall = JudgeSuperBoost._data["jsb_through_wall_toggle_value"];
	end
end




-- Imposta i parametri di Judge ai valori di default
function JudgeParamsToDefault(self, jb)
	self.judge.FIRE_MODE = "single";

	self.judge.stats.damage = jb["jsb_damage_slider_value"];
	self.judge.stats_modifiers = {
		damage = jb["jsb_damage_mul_slider_value"]
	};

	self.judge.fire_mode_data = {
		fire_rate = 60 / jb["jsb_single_fire_rate_slider_value"]
	};

	self.judge.CLIP_AMMO_MAX = jb["jsb_clip_ammo_slider_value"];
	self.judge.NR_CLIPS_MAX = jb["jsb_clips_slider_value"];
	self.judge.AMMO_MAX = self.judge.CLIP_AMMO_MAX * self.judge.NR_CLIPS_MAX;

	self.judge.can_shoot_through_enemy = false;
	self.judge.can_shoot_through_shield = false;
	self.judge.can_shoot_through_wall = false;
end

-- Imposta i parametri di Judge ai valori impostati dall'utente
function JudgeParamsToUserDefined(self)
	SetJudgeFireMode(self, JudgeSuperBoost._data["jsb_fire_mode_mutli_value"]);

	self.judge.stats.damage = JudgeSuperBoost._data["jsb_damage_slider_value"];
	self.judge.stats_modifiers = {
		damage = JudgeSuperBoost._data["jsb_damage_mul_slider_value"]
	};

	self.judge.fire_mode_data = {
		fire_rate = 60 / JudgeSuperBoost._data["jsb_single_fire_rate_slider_value"]
	};

	self.judge.CLIP_AMMO_MAX = JudgeSuperBoost._data["jsb_clip_ammo_slider_value"];
	self.judge.NR_CLIPS_MAX = JudgeSuperBoost._data["jsb_clips_slider_value"];
	self.judge.AMMO_MAX = self.judge.CLIP_AMMO_MAX * self.judge.NR_CLIPS_MAX;

	self.judge.can_shoot_through_enemy = JudgeSuperBoost._data["jsb_through_enemy_toggle_value"];
	self.judge.can_shoot_through_shield = JudgeSuperBoost._data["jsb_through_shield_toggle_value"];
	self.judge.can_shoot_through_wall = JudgeSuperBoost._data["jsb_through_wall_toggle_value"];
end




-- Attiva/Disattiva la mod
function ChangeActiveMod(self, active, jb)
	if active == "on" then
		JudgeSuperBoost._data["jsb_active_toggle_value"] = true;
		JudgeParamsToUserDefined(self);
	else
		JudgeSuperBoost._data["jsb_active_toggle_value"] = false;
		JudgeParamsToDefault(self, jb);
	end
end

-- imposta la modalità di fuoco del Juidge (usato solo per i valori dati dall'utente)
function SetJudgeFireMode(self, value)
	if JudgeSuperBoost._data["jsb_active_toggle_value"] then
		JudgeSuperBoost._data["jsb_fire_mode_mutli_value"] = value;
		if value == 1 then
			self.judge.FIRE_MODE = "single";
		elseif value == 2 then
			self.judge.FIRE_MODE = "auto";
		end
	end
end




-- Imposta il danno del Judge (usato solo per i valori dati dall'utente)
function SetJudgeDamage(self, value)
	JudgeSuperBoost._data["jsb_damage_slider_value"] = math.floor(value);

	if JudgeSuperBoost._data["jsb_active_toggle_value"] then
		self.judge.stats.damage = JudgeSuperBoost._data["jsb_damage_slider_value"];
	end
end

-- Imposta il moltiplicatore di danno del Judge (usato solo per i valori dati dall'utente)
function SetJudgeDamageMultiplier(self, value)
	JudgeSuperBoost._data["jsb_damage_mul_slider_value"] = math.floor(value);

	if JudgeSuperBoost._data["jsb_active_toggle_value"] then
		self.judge.stats_modifiers = {
			damage = JudgeSuperBoost._data["jsb_damage_mul_slider_value"]
		};
	end
end




-- Imposta la cadenza di fuoco singolo
function SetJudgeSingleFireRate(self, value)
	JudgeSuperBoost._data["jsb_single_fire_rate_slider_value"] = math.floor(value);

	if JudgeSuperBoost._data["jsb_active_toggle_value"] then
		self.judge.fire_mode_data = {
			fire_rate = 60 / JudgeSuperBoost._data["jsb_single_fire_rate_slider_value"]
		};
	end
end




-- Imposta i proiettili del caricatore
function SetJudgeClipAmmo(self, value)
	JudgeSuperBoost._data["jsb_clip_ammo_slider_value"] = math.floor(value);

	if JudgeSuperBoost._data["jsb_active_toggle_value"] then
		self.judge.CLIP_AMMO_MAX = JudgeSuperBoost._data["jsb_clip_ammo_slider_value"];
		self.judge.AMMO_MAX = self.judge.CLIP_AMMO_MAX * self.judge.NR_CLIPS_MAX;
	end
end

-- Imposta il numero dei caricatori
function SetJudgeClips(self, value)
	JudgeSuperBoost._data["jsb_clips_slider_value"] = math.floor(value);

	if JudgeSuperBoost._data["jsb_active_toggle_value"] then
		self.judge.NR_CLIPS_MAX = JudgeSuperBoost._data["jsb_clips_slider_value"];
		self.judge.AMMO_MAX = self.judge.CLIP_AMMO_MAX * self.judge.NR_CLIPS_MAX;
	end
end




local old_init = WeaponTweakData.init;
function WeaponTweakData:init(tweak_data)
	old_init(self, tweak_data);

	local judgeBackup = {};


	-- Backup dei valori iniziali
	BackupJudgeParams(self, judgeBackup);

	log("DOPO BACKUP");


	-- Inizializazione Lingua
	Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_JudgeSuperBoost", function( loc )
		loc:load_localization_file( JudgeSuperBoost._path .. "en.txt")
	end)
	

	-- Inizializzazione menu
	Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_JudgeSuperBoost", function(menu_manager)


		-- Callback mod attiva/disattiva
		MenuCallbackHandler.jsb_active_toggle_callback = function(this, item)
			ChangeActiveMod(self, item:value(), judgeBackup);
		end

		-- Callback modalità di fuoco
		MenuCallbackHandler.jsb_fire_mode_mutli_callback = function(this, item)
			SetJudgeFireMode(self, item:value());
		end
		



		-- Callback slider danno
		MenuCallbackHandler.jsb_damage_slider_callback = function(this, item)
			SetJudgeDamage(self, item:value());
		end

		-- Callback slider moltiplicatore danno
		MenuCallbackHandler.jsb_damage_mul_slider_callback = function(this, item)
			SetJudgeDamageMultiplier(self, item:value());
		end




		-- Callback slider cadenza fuoco singolo
		MenuCallbackHandler.jsb_single_fire_rate_slider_callback = function(this, item)
			SetJudgeSingleFireRate(self, item:value());
		end




		-- Callback slider proiettili nel caricatore
		MenuCallbackHandler.jsb_clip_ammo_slider_callback = function(this, item)
			SetJudgeClipAmmo(self, item:value());
		end

		-- Callback slider numero caricatori
		MenuCallbackHandler.jsb_clips_slider_callback = function(this, item)
			SetJudgeClips(self, item:value());
		end




		-- Callback attiva/disattiva trapassa nemici
		MenuCallbackHandler.jsb_through_enemy_toggle_callback = function(this, item)
			if JudgeSuperBoost._data["jsb_active_toggle_value"] then
				if item:value() == "on" then
					JudgeSuperBoost._data["jsb_through_enemy_toggle_value"] = true;
				else
					JudgeSuperBoost._data["jsb_through_enemy_toggle_value"] = false;
				end
				self.judge.can_shoot_through_enemy = JudgeSuperBoost._data["jsb_through_enemy_toggle_value"];
			end
		end

		-- Callback attiva/disattiva trapassa scudi
		MenuCallbackHandler.jsb_through_shield_toggle_callback = function(this, item)
			if JudgeSuperBoost._data["jsb_active_toggle_value"] then
				if item:value() == "on" then
					JudgeSuperBoost._data["jsb_through_shield_toggle_value"] = true;
				else
					JudgeSuperBoost._data["jsb_through_shield_toggle_value"] = false;
				end
				self.judge.can_shoot_through_shield = JudgeSuperBoost._data["jsb_through_shield_toggle_value"];
			end
		end

		-- Callback attiva/disattiva trapassa muri
		MenuCallbackHandler.jsb_through_wall_toggle_callback = function(this, item)
			if JudgeSuperBoost._data["jsb_active_toggle_value"] then
				if item:value() == "on" then
					JudgeSuperBoost._data["jsb_through_wall_toggle_value"] = true;
				else
					JudgeSuperBoost._data["jsb_through_wall_toggle_value"] = false;
				end
				self.judge.can_shoot_through_wall = JudgeSuperBoost._data["jsb_through_wall_toggle_value"];
			end
		end




		-- Callback chiusura del menu
		MenuCallbackHandler.judge_superboost_menu_close = function(this)
			JudgeSuperBoost:Save()
		end


		log("DOPO CALLBACK");

		-- Load dei parametri iniziali
		JudgeSuperBoost:Load()


		log("DOPO LOAD");


		-- Settaggio dei parametri iniziali al Judge
		SetInitialJudgeValues(self);

		log("DOPO INIT VALORI");


		-- Import del menu in json
		MenuHelper:LoadFromJsonFile( JudgeSuperBoost._path .. "menu.txt", JudgeSuperBoost, JudgeSuperBoost._data )
	

		
		log("DOPO LOAD MENU");
	end)
end;