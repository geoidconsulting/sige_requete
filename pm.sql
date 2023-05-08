
CREATE OR REPLACE VIEW public."_vue_taux_brut_scolarisation_post_primaire_EFTPCJ"
 AS
 SELECT 
    prov_nb_eleve_post_primaire.code_region,
    prov_nb_eleve_post_primaire.region,
    prov_nb_eleve_post_primaire.code_province,
    prov_nb_eleve_post_primaire.province,
    prov_nb_eleve_post_primaire.code_type_annee,
    prov_nb_eleve_post_primaire.libelle_type_annee,
    pop_12_15_ans.pop_12_15_ans_g AS pop_12_15_ans_g_post_primaire,
    pop_12_15_ans.pop_12_15_ans_f AS pop_12_15_ans_f_post_primaire,
    prov_nb_eleve_post_primaire.prov_insc_f AS prov_insc_f_post_primaire,
    prov_nb_eleve_post_primaire.prov_insc_g AS prov_insc_g_post_primaire
   FROM pop_12_15_ans,
    prov_nb_eleve_post_primaire
  WHERE pop_12_15_ans.code_type_annee = prov_nb_eleve_post_primaire.code_type_annee 
  AND pop_12_15_ans.code_regroupement = prov_nb_eleve_post_primaire.code_province 
  AND prov_nb_eleve_post_primaire.code_systeme_enseignement = 4;

ALTER TABLE public."_vue_taux_brut_scolarisation_post_primaire_EFTPCJ"
    OWNER TO postgres;
COMMENT ON VIEW public."_vue_taux_brut_scolarisation_post_primaire_EFTPCJ"
    IS 'taux brut de scolarisation post primaire enseigenement technique cours du jour';

-- View: public._vue_taux_brut_scolarisation_post_primaire_EFTPCS

-- DROP VIEW public."_vue_taux_brut_scolarisation_post_primaire_EFTPCS";

CREATE OR REPLACE VIEW public."_vue_taux_brut_scolarisation_post_primaire_EFTPCS"
 AS
 SELECT prov_nb_eleve_post_primaire.code_province,
    prov_nb_eleve_post_primaire.province,
    prov_nb_eleve_post_primaire.code_type_annee,
    prov_nb_eleve_post_primaire.libelle_type_annee,
    pop_12_15_ans.pop_12_15_ans_g AS pop_12_15_ans_g_post_primaire,
    pop_12_15_ans.pop_12_15_ans_f AS pop_12_15_ans_f_post_primaire,
    prov_nb_eleve_post_primaire.prov_insc_f AS prov_insc_f_post_primaire,
    prov_nb_eleve_post_primaire.prov_insc_g AS prov_insc_g_post_primaire
   FROM pop_12_15_ans,
    prov_nb_eleve_post_primaire
  WHERE pop_12_15_ans.code_type_annee = prov_nb_eleve_post_primaire.code_type_annee 
  AND pop_12_15_ans.code_regroupement = prov_nb_eleve_post_primaire.code_province 
  AND prov_nb_eleve_post_primaire.code_systeme_enseignement = 6;

ALTER TABLE public."_vue_taux_brut_scolarisation_post_primaire_EFTPCS"
    OWNER TO postgres;
COMMENT ON VIEW public."_vue_taux_brut_scolarisation_post_primaire_EFTPCS"
    IS 'taux brut de scolarisation post primaire enseigenement technique cours du soir';

-- View: public._vue_taux_brut_scolarisation_post_primaire_EGCJ

-- DROP VIEW public."_vue_taux_brut_scolarisation_post_primaire_EGCJ";

CREATE OR REPLACE VIEW public."_vue_taux_brut_scolarisation_post_primaire_EGCJ"
 AS
 SELECT prov_nb_eleve_post_primaire.code_province,
    prov_nb_eleve_post_primaire.province,
    prov_nb_eleve_post_primaire.code_type_annee,
    prov_nb_eleve_post_primaire.libelle_type_annee,
    pop_12_15_ans.pop_12_15_ans_g AS pop_12_15_ans_g_post_primaire,
    pop_12_15_ans.pop_12_15_ans_f AS pop_12_15_ans_f_post_primaire,
    prov_nb_eleve_post_primaire.prov_insc_f AS prov_insc_f_post_primaire,
    prov_nb_eleve_post_primaire.prov_insc_g AS prov_insc_g_post_primaire
   FROM pop_12_15_ans,
    prov_nb_eleve_post_primaire
  WHERE pop_12_15_ans.code_type_annee = prov_nb_eleve_post_primaire.code_type_annee 
  AND pop_12_15_ans.code_regroupement = prov_nb_eleve_post_primaire.code_province 
  AND prov_nb_eleve_post_primaire.code_systeme_enseignement = 3;

ALTER TABLE public."_vue_taux_brut_scolarisation_post_primaire_EGCJ"
    OWNER TO postgres;
COMMENT ON VIEW public."_vue_taux_brut_scolarisation_post_primaire_EGCJ"
    IS 'taux brut de scolarisation post primaire enseigenement général cours du jour';

-- View: public._vue_taux_brut_scolarisation_post_primaire_EGCS

-- DROP VIEW public."_vue_taux_brut_scolarisation_post_primaire_EGCS";

CREATE OR REPLACE VIEW public."_vue_taux_brut_scolarisation_post_primaire_EGCS"
 AS
 SELECT prov_nb_eleve_post_primaire.code_province,
    prov_nb_eleve_post_primaire.province,
    prov_nb_eleve_post_primaire.code_type_annee,
    prov_nb_eleve_post_primaire.libelle_type_annee,
    pop_12_15_ans.pop_12_15_ans_g AS pop_12_15_ans_g_post_primaire,
    pop_12_15_ans.pop_12_15_ans_f AS pop_12_15_ans_f_post_primaire,
    prov_nb_eleve_post_primaire.prov_insc_f AS prov_insc_f_post_primaire,
    prov_nb_eleve_post_primaire.prov_insc_g AS prov_insc_g_post_primaire
   FROM pop_12_15_ans,
    prov_nb_eleve_post_primaire
  WHERE pop_12_15_ans.code_type_annee = prov_nb_eleve_post_primaire.code_type_annee 
  AND pop_12_15_ans.code_regroupement = prov_nb_eleve_post_primaire.code_province 
  AND prov_nb_eleve_post_primaire.code_systeme_enseignement = 5;

ALTER TABLE public."_vue_taux_brut_scolarisation_post_primaire_EGCS"
    OWNER TO postgres;
COMMENT ON VIEW public."_vue_taux_brut_scolarisation_post_primaire_EGCS"
    IS '''taux brut de scolarisation post primaire enseigenement général cours du soir';


-------------------------------
SELECT * FROM type_niveau tn,type_niveau_systeme tns,type_systeme_enseignement tse
 where tn.code_type_niveau=tns.code_type_niveau 
 and tns.code_type_systeme_enseignement = tse.code_type_systeme_enseignement
---------------------------------


-- View: public._vue_taux_brut_scolarisation_secondaire_EFTPCJ

-- DROP VIEW public."_vue_taux_brut_scolarisation_secondaire_EFTPCJ";

CREATE OR REPLACE VIEW public."_vue_taux_brut_scolarisation_secondaire_EFTPCJ"
 AS
 SELECT prov_nb_eleve.code_province,
    prov_nb_eleve.province,
    prov_nb_eleve.code_type_annee,
    prov_nb_eleve.libelle_type_annee,
    pop_16_18_ans.pop_16_18_ans_g AS pop_16_18_ans_g_post_primaire,
    pop_16_18_ans.pop_16_18_ans_f AS pop_16_18_ans_f_post_primaire,
    prov_nb_eleve.prov_insc_f AS prov_insc_f_post_primaire,
    prov_nb_eleve.prov_insc_g AS prov_insc_g_post_primaire
   FROM pop_16_18_ans,
    prov_nb_eleve
  WHERE pop_16_18_ans.code_type_annee = prov_nb_eleve.code_type_annee AND pop_16_18_ans.code_regroupement = prov_nb_eleve.code_province AND prov_nb_eleve.code_systeme_enseignement = 4;

ALTER TABLE public."_vue_taux_brut_scolarisation_secondaire_EFTPCJ"
    OWNER TO postgres;

-- View: public._vue_taux_brut_scolarisation_secondaire_EFTPCS

-- DROP VIEW public."_vue_taux_brut_scolarisation_secondaire_EFTPCS";

CREATE OR REPLACE VIEW public."_vue_taux_brut_scolarisation_secondaire_EFTPCS"
 AS
 SELECT prov_nb_eleve.code_province,
    prov_nb_eleve.province,
    prov_nb_eleve.code_type_annee,
    prov_nb_eleve.libelle_type_annee,
    pop_16_18_ans.pop_16_18_ans_g AS pop_16_18_ans_g_post_primaire,
    pop_16_18_ans.pop_16_18_ans_f AS pop_16_18_ans_f_post_primaire,
    prov_nb_eleve.prov_insc_f AS prov_insc_f_post_primaire,
    prov_nb_eleve.prov_insc_g AS prov_insc_g_post_primaire
   FROM pop_16_18_ans,
    prov_nb_eleve
  WHERE pop_16_18_ans.code_type_annee = prov_nb_eleve.code_type_annee AND pop_16_18_ans.code_regroupement = prov_nb_eleve.code_province AND prov_nb_eleve.code_systeme_enseignement = 6;

ALTER TABLE public."_vue_taux_brut_scolarisation_secondaire_EFTPCS"
    OWNER TO postgres;

-- View: public._vue_taux_brut_scolarisation_secondaire_EGCJ

-- DROP VIEW public."_vue_taux_brut_scolarisation_secondaire_EGCJ";

CREATE OR REPLACE VIEW public."_vue_taux_brut_scolarisation_secondaire_EGCJ"
 AS
 SELECT prov_nb_eleve.code_province,
    prov_nb_eleve.province,
    prov_nb_eleve.code_type_annee,
    prov_nb_eleve.libelle_type_annee,
    pop_16_18_ans.pop_16_18_ans_g AS pop_16_18_ans_g_post_primaire,
    pop_16_18_ans.pop_16_18_ans_f AS pop_16_18_ans_f_post_primaire,
    prov_nb_eleve.prov_insc_f AS prov_insc_f_post_primaire,
    prov_nb_eleve.prov_insc_g AS prov_insc_g_post_primaire
   FROM pop_16_18_ans,
    prov_nb_eleve
  WHERE pop_16_18_ans.code_type_annee = prov_nb_eleve.code_type_annee AND pop_16_18_ans.code_regroupement = prov_nb_eleve.code_province AND prov_nb_eleve.code_systeme_enseignement = 3;

ALTER TABLE public."_vue_taux_brut_scolarisation_secondaire_EGCJ"
    OWNER TO postgres;
COMMENT ON VIEW public."_vue_taux_brut_scolarisation_secondaire_EGCJ"
    IS 'taux brut de scolarisation secondaire enseigenement technique cours du soir';

-- View: public._vue_taux_brut_scolarisation_secondaire_EGCS

-- DROP VIEW public."_vue_taux_brut_scolarisation_secondaire_EGCS";

CREATE OR REPLACE VIEW public."_vue_taux_brut_scolarisation_secondaire_EGCS"
 AS
 SELECT prov_nb_eleve.code_province,
    prov_nb_eleve.province,
    prov_nb_eleve.code_type_annee,
    prov_nb_eleve.libelle_type_annee,
    pop_16_18_ans.pop_16_18_ans_g AS pop_16_18_ans_g_post_primaire,
    pop_16_18_ans.pop_16_18_ans_f AS pop_16_18_ans_f_post_primaire,
    prov_nb_eleve.prov_insc_f AS prov_insc_f_post_primaire,
    prov_nb_eleve.prov_insc_g AS prov_insc_g_post_primaire
   FROM pop_16_18_ans,
    prov_nb_eleve
  WHERE pop_16_18_ans.code_type_annee = prov_nb_eleve.code_type_annee AND pop_16_18_ans.code_regroupement = prov_nb_eleve.code_province AND prov_nb_eleve.code_systeme_enseignement = 5;

ALTER TABLE public."_vue_taux_brut_scolarisation_secondaire_EGCS"
    OWNER TO postgres;


-- View: public._vue_taux_brut_scolarisation_secondaire

-- DROP VIEW public._vue_taux_brut_scolarisation_secondaire;

CREATE OR REPLACE VIEW public._vue_taux_brut_scolarisation_secondaire
 AS
 SELECT prov_nb_eleve.code_province,
    prov_nb_eleve.province,
    prov_nb_eleve.code_type_annee,
    prov_nb_eleve.libelle_type_annee,
    prov_nb_eleve.code_systeme_enseignement,
    pop_16_18_ans.pop_16_18_ans_g AS pop_16_18_ans_g_secondaire,
    pop_16_18_ans.pop_16_18_ans_f AS pop_16_18_ans_f_secondaire,
    prov_nb_eleve.prov_insc_f AS prov_insc_f_secondaire,
    prov_nb_eleve.prov_insc_g AS prov_insc_g_secondaire
   FROM pop_16_18_ans
     JOIN prov_nb_eleve ON pop_16_18_ans.code_type_annee = prov_nb_eleve.code_type_annee AND pop_16_18_ans.code_regroupement = prov_nb_eleve.code_province
  WHERE prov_nb_eleve.code_systeme_enseignement = ANY (ARRAY[3, 4, 5, 6]);

ALTER TABLE public._vue_taux_brut_scolarisation_secondaire
    OWNER TO postgres;
COMMENT ON VIEW public._vue_taux_brut_scolarisation_secondaire
    IS 'taux brut de scolarisation enseigenement secondaire';



-- View: public._vue_taux_net_scolairisation_secondaire

-- DROP VIEW public._vue_taux_net_scolairisation_secondaire;

CREATE OR REPLACE VIEW public._vue_taux_net_scolarisation_secondaire
 AS
 SELECT prov_nb_eleve_16_18_ans.code_region,
    prov_nb_eleve_16_18_ans.region,
    prov_nb_eleve_16_18_ans.code_province,
    prov_nb_eleve_16_18_ans.province,
    prov_nb_eleve_16_18_ans.code_type_annee,
    prov_nb_eleve_16_18_ans.libelle_type_annee,
    prov_nb_eleve_16_18_ans.insc_g_16_18 AS inscr_prov_g_16_18,
    prov_nb_eleve_16_18_ans.insc_f_16_18 AS inscr_prov_f_16_18,
    pop_16_18_ans.pop_16_18_ans_g AS pop_prov_g_16_18,
    pop_16_18_ans.pop_16_18_ans_f AS pop_nat_f_16_18
   FROM pop_16_18_ans,
    prov_nb_eleve_16_18_ans
  WHERE pop_16_18_ans.code_type_annee = prov_nb_eleve_16_18_ans.code_type_annee;

ALTER TABLE public._vue_taux_net_scolarisation_secondaire
    OWNER TO postgres;



-- View: public.prov_nb_eleve_16_18_ans

-- DROP VIEW public.prov_nb_eleve_16_18_ans;

CREATE OR REPLACE VIEW public.prov_nb_eleve_16_18_ans
 AS
 SELECT atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    sum(effectif_gp_par_age.inscrits_garcons) AS insc_g_16_18,
    sum(effectif_gp_par_age.inscrits_filles) AS insc_f_16_18
   FROM effectif_gp_par_age,
    atlas_admin
  WHERE effectif_gp_par_age.code_etablissement = atlas_admin.code_etablissement AND effectif_gp_par_age.code_type_annee = atlas_admin.code_type_annee AND (effectif_gp_par_age.code_type_age = ANY (ARRAY[17, 18, 19]))
  GROUP BY atlas_admin.code_region, atlas_admin.region, atlas_admin.code_province, atlas_admin.province, atlas_admin.libelle_type_annee, atlas_admin.code_type_annee;

ALTER TABLE public.prov_nb_eleve_16_18_ans
    OWNER TO postgres;

