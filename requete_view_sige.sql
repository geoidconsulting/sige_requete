--Les Vues--

                --Vue Intermédiaire--
-- View: public.atlas_commune

-- DROP VIEW public.atlas_commune;

CREATE OR REPLACE VIEW public.atlas_commune
 AS
 SELECT commune.code_regroupement AS code_commune,
    commune.libelle_regroupement AS commune,
    province.code_regroupement AS code_province,
    province.libelle_regroupement AS province,
    region.code_regroupement AS code_region,
    region.libelle_regroupement AS region,
    etablissement.code_etablissement,
    etablissement.nom_etablissement,
    type_systeme_enseignement.code_type_systeme_enseignement AS code_systeme_enseignement,
    type_systeme_enseignement.libelle_type_systeme_enseignement AS systeme_enseignement,
    type_annee.code_type_annee,
    type_annee.libelle_type_annee
   FROM regroupement commune,
    regroupement province,
    regroupement region,
    liaisons province_dans_region,
    liaisons commune_dans_province,
    etablissement,
    etablissement_regroupement,
    type_systeme_enseignement,
    type_annee
  WHERE etablissement.code_etablissement = etablissement_regroupement.code_etablissement AND etablissement.code_type_systeme_enseignement = type_systeme_enseignement.code_type_systeme_enseignement AND etablissement_regroupement.code_regroupement = commune.code_regroupement AND etablissement_regroupement.code_type_annee = type_annee.code_type_annee AND commune.code_regroupement = commune_dans_province.code_regroupement AND commune_dans_province.reg_code_regroupement = province.code_regroupement AND province.code_regroupement = province_dans_region.code_regroupement AND province_dans_region.reg_code_regroupement = region.code_regroupement AND region.code_type_regroupement = 1 AND province.code_type_regroupement = 2 AND commune.code_type_regroupement = 3;

ALTER TABLE public.atlas_commune
    OWNER TO postgres;


-- View: public.atlas_admin

-- DROP VIEW public.atlas_admin;

CREATE OR REPLACE VIEW public.atlas_admin
 AS
 SELECT atlas_commune.code_commune,
    atlas_commune.commune,
    atlas_commune.code_province,
    atlas_commune.province,
    atlas_commune.code_region,
    atlas_commune.region,
    atlas_commune.code_etablissement,
    atlas_commune.nom_etablissement,
    atlas_commune.code_systeme_enseignement,
    atlas_commune.systeme_enseignement,
    atlas_commune.code_type_annee,
    atlas_commune.libelle_type_annee,
    type_etablissement.libelle_type_etablissement,
    type_statut_etablissement.libelle_type_statut_etablissement,
        CASE
            WHEN type_statut_etablissement.libelle_type_statut_etablissement::text = 'Public'::text THEN 'Public'::text
            ELSE 'Privé'::text
        END AS statut_etablisement_regroup,
    type_reconnaissance.libelle_type_reconnaissance,
    type_promoteur.libelle_type_promoteur,
    type_sociologique.libelle_type_sociologique,
    type_recrutement.libelle_type_recrutement,
    type_cpaf.libelle_type_cpaf,
    type_approche.libelle_type_approche,
    type_lieu_alphabetisation.libelle_type_lieu_alphabetisation,
    type_formule.libelle_type_formule,
    type_operateur.libelle_type_operateur,
    type_financement.libelle_type_financement,
    type_langue.libelle_type_langue,
    type_formalite.libelle_type_formalite,
        CASE
            WHEN atlas_commune.code_systeme_enseignement = 3 OR atlas_commune.code_systeme_enseignement = 5 THEN 'EG'::text
            WHEN atlas_commune.code_systeme_enseignement = 4 OR atlas_commune.code_systeme_enseignement = 6 THEN 'EFTP'::text
            ELSE NULL::text
        END AS systeme_enseignement_regroup,
        CASE
            WHEN type_statut_etablissement.libelle_type_statut_etablissement::text = 'Public'::text THEN 'Public'::text
            WHEN type_statut_etablissement.libelle_type_statut_etablissement::text = 'Communautaire'::text THEN 'Communautaire'::text
            ELSE 'Privé'::text
        END AS statut_etablisement_prescolaire
   FROM atlas_commune
     LEFT JOIN donnees_etablissement ON donnees_etablissement.code_etablissement = atlas_commune.code_etablissement AND donnees_etablissement.code_type_annee = atlas_commune.code_type_annee
     LEFT JOIN type_etablissement ON donnees_etablissement.code_type_etablissement = type_etablissement.code_type_etablissement
     LEFT JOIN type_statut_etablissement ON donnees_etablissement.code_type_statut_etablissement = type_statut_etablissement.code_type_statut_etablissement
     LEFT JOIN type_reconnaissance ON donnees_etablissement.code_type_reconnaissance = type_reconnaissance.code_type_reconnaissance
     LEFT JOIN type_promoteur ON donnees_etablissement.code_type_promoteur = type_promoteur.code_type_promoteur
     LEFT JOIN type_sociologique ON donnees_etablissement.code_type_sociologique = type_sociologique.code_type_sociologique
     LEFT JOIN type_recrutement ON donnees_etablissement.code_type_recrutement = type_recrutement.code_type_recrutement
     LEFT JOIN type_cpaf ON donnees_etablissement.code_type_cpaf = type_cpaf.code_type_cpaf
     LEFT JOIN type_approche ON donnees_etablissement.code_type_approche = type_approche.code_type_approche
     LEFT JOIN type_lieu_alphabetisation ON donnees_etablissement.code_type_lieu_alphabetisation = type_lieu_alphabetisation.code_type_lieu_alphabetisation
     LEFT JOIN type_formule ON donnees_etablissement.code_type_formule = type_formule.code_type_formule
     LEFT JOIN type_operateur ON donnees_etablissement.code_type_operateur = type_operateur.code_type_operateur
     LEFT JOIN type_financement ON donnees_etablissement.code_type_financement = type_financement.code_type_financement
     LEFT JOIN type_langue ON donnees_etablissement.code_type_langue = type_langue.code_type_langue
     LEFT JOIN type_formalite ON donnees_etablissement.code_type_formalite = type_formalite.code_type_formalite;

ALTER TABLE public.atlas_admin
    OWNER TO postgres;


-- View: public.effectif_gp

-- DROP VIEW public.effectif_gp;

CREATE OR REPLACE VIEW public.effectif_gp
 AS
 SELECT effectif_gp_par_age.code_type_annee,
    effectif_gp_par_age.code_etablissement,
    effectif_gp_par_age.numero_ordre_groupe,
    sum(effectif_gp_par_age.inscrits_garcons) AS inscrit_g_gp,
    sum(effectif_gp_par_age.inscrits_filles) AS inscrit_f_gp
   FROM effectif_gp_par_age
  GROUP BY effectif_gp_par_age.code_type_annee, effectif_gp_par_age.code_etablissement, effectif_gp_par_age.numero_ordre_groupe;

ALTER TABLE public.effectif_gp
    OWNER TO postgres;

-- View: public.enseignant_age_experience_pro

-- DROP VIEW public.enseignant_age_experience_pro;

CREATE OR REPLACE VIEW public.enseignant_age_experience_pro
 AS
 SELECT enseignant_etablissement.identifiant_enseignant,
    enseignant_etablissement.code_type_annee,
    enseignant_etablissement.code_etablissement,
    enseignant_etablissement.code_type_fonction,
    enseignant_etablissement.code_type_formule,
    enseignant_etablissement.code_type_situation_adminis,
    enseignant_etablissement.code_type_emploi,
    enseignant_etablissement.code_type_situation_matrimoniale,
    enseignant_etablissement.code_type_matiere,
    enseignant_etablissement.code_type_diplome_professionnel,
    enseignant_etablissement.code_type_diplome_academique,
    enseignant_etablissement.numero_ordre_enseignant,
    enseignant_etablissement.experience_professionnelle,
    enseignant_etablissement.formation_esu,
    enseignant_etablissement.formation_esh,
    enseignant_etablissement.nb_visite_classe,
    enseignant_etablissement.nb_formation_continue,
    enseignant_etablissement.nbre_session_formation,
    enseignant_etablissement.nbre_cp,
    enseignant_etablissement.nbre_hyg_ass,
    enseignant_etablissement.nbre_ist,
    enseignant_etablissement.nbre_visite_classe,
    enseignant_etablissement.nbre_esh,
    enseignant_etablissement.nombre_annee_etablissement,
    enseignant_etablissement.matiere_1,
    enseignant_etablissement.volume_heure_mat_1,
    enseignant_etablissement.matiere_2,
    enseignant_etablissement.volume_heure_mat_2,
    enseignant_etablissement.nb_heures_assures_1c,
    enseignant_etablissement.nb_heures_assures_2c,
    enseignant_etablissement.code_type_niveau,
    enseignant.date_naiss_enseignant,
    enseignant.code_type_sexe,
    type_annee.libelle_type_annee,
        CASE enseignant.date_naiss_enseignant IS NOT NULL
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) < 30 THEN 'moins de 30 ans'::text
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) <= 40 THEN '30 à 40 ans'::text
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) <= 50 THEN '41 à 50 ans'::text
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) > 50 THEN 'plus de 50 ans'::text
            ELSE 'indeterminé'::text
        END AS tranche_age_enseignant,
        CASE enseignant.date_naiss_enseignant IS NOT NULL
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) < 30 THEN 1
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) <= 40 THEN 2
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) <= 50 THEN 3
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) > 50 THEN 4
            ELSE 255
        END AS ordre_tranche_age_enseignant,
        CASE enseignant_etablissement.experience_professionnelle IS NOT NULL
            WHEN enseignant_etablissement.experience_professionnelle <= 5 THEN '1 à 5 ans'::text
            WHEN enseignant_etablissement.experience_professionnelle <= 10 THEN '6 à 10 ans'::text
            WHEN enseignant_etablissement.experience_professionnelle <= 15 THEN '11 à 15 ans'::text
            WHEN enseignant_etablissement.experience_professionnelle > 15 THEN 'plus de 15 ans'::text
            ELSE 'indeterminé'::text
        END AS experience_enseignant,
        CASE enseignant_etablissement.experience_professionnelle IS NOT NULL
            WHEN enseignant_etablissement.experience_professionnelle <= 5 THEN 1
            WHEN enseignant_etablissement.experience_professionnelle <= 10 THEN 2
            WHEN enseignant_etablissement.experience_professionnelle <= 15 THEN 3
            WHEN enseignant_etablissement.experience_professionnelle > 15 THEN 4
            ELSE 255
        END AS ordre_experience_enseignant,
        CASE enseignant.date_naiss_enseignant IS NOT NULL
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) < 26 THEN 'moins de 26 ans'::text
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) <= 35 THEN '27 à 35 ans'::text
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) <= 45 THEN '36 à 45 ans'::text
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) <= 55 THEN '46 à 55 ans'::text
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) <= 59 THEN '56 à 59 ans'::text
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) >= 60 THEN 'plus de 60 ans'::text
            ELSE 'indeterminé'::text
        END AS tranche_age_enseignant_prescolaire,
        CASE enseignant.date_naiss_enseignant IS NOT NULL
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) < 26 THEN 1
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) <= 35 THEN 2
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) <= 45 THEN 3
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) <= 55 THEN 4
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) <= 59 THEN 5
            WHEN ("substring"(type_annee.libelle_type_annee::text, 6, 10)::integer - "substring"(enseignant.date_naiss_enseignant::text, 1, 4)::integer) >= 60 THEN 6
            ELSE 255
        END AS ordre_tranche_age_enseignant_prescolaire,
        CASE enseignant_etablissement.experience_professionnelle IS NOT NULL
            WHEN enseignant_etablissement.experience_professionnelle < 2 THEN '<2 ans '::text
            WHEN enseignant_etablissement.experience_professionnelle <= 5 THEN '2 à 5 ans'::text
            WHEN enseignant_etablissement.experience_professionnelle <= 10 THEN '6 à 10 ans'::text
            WHEN enseignant_etablissement.experience_professionnelle > 10 THEN '>10 ans'::text
            ELSE 'indeterminé'::text
        END AS experience_enseignant_prescolaire,
        CASE enseignant_etablissement.experience_professionnelle IS NOT NULL
            WHEN enseignant_etablissement.experience_professionnelle <= 2 THEN 1
            WHEN enseignant_etablissement.experience_professionnelle <= 5 THEN 2
            WHEN enseignant_etablissement.experience_professionnelle <= 10 THEN 3
            WHEN enseignant_etablissement.experience_professionnelle > 10 THEN 4
            ELSE 255
        END AS ordre_experience_enseignant_prescolaire,
        CASE
            WHEN enseignant_etablissement.code_type_diplome_academique = 2 OR enseignant_etablissement.code_type_diplome_academique = 3 THEN 'BEPC/CAP'::text
            WHEN enseignant_etablissement.code_type_diplome_academique = 5 OR enseignant_etablissement.code_type_diplome_academique = 6 THEN 'BAC/BEP'::text
            WHEN enseignant_etablissement.code_type_diplome_academique = 7 OR enseignant_etablissement.code_type_diplome_academique = 8 OR enseignant_etablissement.code_type_diplome_academique = 10 OR enseignant_etablissement.code_type_diplome_academique = 12 OR enseignant_etablissement.code_type_diplome_academique = 13 THEN 'supérieur au BAC'::text
            WHEN enseignant_etablissement.code_type_diplome_academique = 1 THEN 'CEP'::text
            ELSE 'ND'::text
        END AS diplome_enseignant_prescolaire,
        CASE
            WHEN enseignant_etablissement.code_type_diplome_academique = 2 OR enseignant_etablissement.code_type_diplome_academique = 3 THEN 3
            WHEN enseignant_etablissement.code_type_diplome_academique = 5 OR enseignant_etablissement.code_type_diplome_academique = 6 THEN 2
            WHEN enseignant_etablissement.code_type_diplome_academique = 7 OR enseignant_etablissement.code_type_diplome_academique = 8 OR enseignant_etablissement.code_type_diplome_academique = 10 OR enseignant_etablissement.code_type_diplome_academique = 12 OR enseignant_etablissement.code_type_diplome_academique = 13 THEN 1
            WHEN enseignant_etablissement.code_type_diplome_academique = 1 THEN 4
            ELSE 255
        END AS ordre_diplome_enseignant_prescolaire
   FROM enseignant,
    enseignant_etablissement,
    type_annee
  WHERE enseignant.identifiant_enseignant = enseignant_etablissement.identifiant_enseignant AND enseignant_etablissement.code_type_annee = type_annee.code_type_annee;

ALTER TABLE public.enseignant_age_experience_pro
    OWNER TO postgres;

-- View: public.enseignant_etab_infos_de_base

-- DROP VIEW public.enseignant_etab_infos_de_base;

CREATE OR REPLACE VIEW public.enseignant_etab_infos_de_base
 AS
 SELECT atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_sociologique,
    type_fonction.libelle_type_fonction,
    type_fonction.ordre_type_fonction,
    type_emploi.libelle_type_emploi,
    type_emploi.ordre_type_emploi,
    type_sexe.libelle_type_sexe,
    type_sexe.ordre_type_sexe,
    enseignant_etablissement.identifiant_enseignant,
    type_diplome_academique.libelle_type_diplome_academique,
    type_diplome_academique.ordre_type_diplome_academique,
    type_diplome_professionnel.libelle_type_diplome_professionnel,
    type_diplome_professionnel.ordre_type_diplome_professionnel,
    enseignant_etablissement.experience_professionnelle
   FROM enseignant,
    atlas_admin,
    type_sexe,
    enseignant_etablissement
     LEFT JOIN type_emploi ON enseignant_etablissement.code_type_emploi = type_emploi.code_type_emploi
     LEFT JOIN type_diplome_professionnel ON enseignant_etablissement.code_type_diplome_professionnel = type_diplome_professionnel.code_type_diplome_professionnel
     LEFT JOIN type_diplome_academique ON enseignant_etablissement.code_type_diplome_academique = type_diplome_academique.code_type_diplome_academique
     LEFT JOIN type_fonction ON enseignant_etablissement.code_type_fonction = type_fonction.code_type_fonction
  WHERE enseignant_etablissement.identifiant_enseignant = enseignant.identifiant_enseignant AND enseignant_etablissement.code_etablissement = atlas_admin.code_etablissement AND enseignant_etablissement.code_type_annee = atlas_admin.code_type_annee AND enseignant.code_type_sexe = type_sexe.code_type_sexe;

ALTER TABLE public.enseignant_etab_infos_de_base
    OWNER TO postgres;

-- View: public.etab_nouveaux_inscrits_cp1

-- DROP VIEW public.etab_nouveaux_inscrits_cp1;

CREATE OR REPLACE VIEW public.etab_nouveaux_inscrits_cp1
 AS
 SELECT nouveaux_inscrits.code_type_annee,
    nouveaux_inscrits.code_etablissement,
    sum(nouveaux_inscrits.nouveaux_inscrits_garcons) AS nvx_insc_g_etab,
    sum(nouveaux_inscrits.nouveaux_inscrits_filles) AS nvx_insc_f_etab
   FROM nouveaux_inscrits
  WHERE nouveaux_inscrits.code_type_niveau = 4
  GROUP BY nouveaux_inscrits.code_type_annee, nouveaux_inscrits.code_etablissement;

ALTER TABLE public.etab_nouveaux_inscrits_cp1
    OWNER TO postgres;

-- View: public.etab_nouveaux_inscrits_prescolaire

-- DROP VIEW public.etab_nouveaux_inscrits_prescolaire;

CREATE OR REPLACE VIEW public.etab_nouveaux_inscrits_prescolaire
 AS
 SELECT nouveaux_inscrits_prescolaires.code_etablissement,
    nouveaux_inscrits_prescolaires.code_type_annee,
    sum(nouveaux_inscrits_prescolaires.prescolaire_garcons) AS presc_insc_g,
    sum(nouveaux_inscrits_prescolaires.prescolaire_filles) AS presc_inc_f
   FROM nouveaux_inscrits_prescolaires
  GROUP BY nouveaux_inscrits_prescolaires.code_etablissement, nouveaux_inscrits_prescolaires.code_type_annee;

ALTER TABLE public.etab_nouveaux_inscrits_prescolaire
    OWNER TO postgres;

-- View: public.nb_eleve

-- DROP VIEW public.nb_eleve;

CREATE OR REPLACE VIEW public.nb_eleve
 AS
 SELECT effectif_gp_par_age.code_etablissement,
    effectif_gp_par_age.code_type_annee,
    sum(effectif_gp_par_age.inscrits_garcons) AS garcons,
    sum(effectif_gp_par_age.inscrits_filles) AS filles
   FROM effectif_gp_par_age
  GROUP BY effectif_gp_par_age.code_etablissement, effectif_gp_par_age.code_type_annee;

ALTER TABLE public.nb_eleve
    OWNER TO postgres;

-- View: public.nb_enseignant_charge_cours

-- DROP VIEW public.nb_enseignant_charge_cours;

CREATE OR REPLACE VIEW public.nb_enseignant_charge_cours
 AS
 SELECT enseignant_groupe_pedagogique.code_etablissement,
    enseignant_groupe_pedagogique.code_type_annee,
    count(enseignant_groupe_pedagogique.identifiant_enseignant) AS enseignant
   FROM enseignant_groupe_pedagogique
  GROUP BY enseignant_groupe_pedagogique.code_etablissement, enseignant_groupe_pedagogique.code_type_annee;

ALTER TABLE public.nb_enseignant_charge_cours
    OWNER TO postgres;

-- View: public.nb_salle_classe

-- DROP VIEW public.nb_salle_classe;

CREATE OR REPLACE VIEW public.nb_salle_classe
 AS
 SELECT local.code_type_annee,
    local.code_etablissement,
    count(local.numero_local) AS salles_classes
   FROM local
  WHERE local.code_type_local = 15
  GROUP BY local.code_type_annee, local.code_etablissement;

ALTER TABLE public.nb_salle_classe
    OWNER TO postgres;

-- View: public.nb_salle_classe_sous_paillote

-- DROP VIEW public.nb_salle_classe_sous_paillote;

CREATE OR REPLACE VIEW public.nb_salle_classe_sous_paillote
 AS
 SELECT local.code_etablissement,
    local.code_type_annee,
    count(local.numero_local) AS salle_sous_paillote
   FROM local
  WHERE local.code_type_local = 15 AND (local.code_type_nature_mur = ANY (ARRAY[2, 4, 5, 6, 7])) OR local.code_type_local = 15 AND (local.code_type_nature_toit = ANY (ARRAY[3, 4, 5, 6]))
  GROUP BY local.code_etablissement, local.code_type_annee;

ALTER TABLE public.nb_salle_classe_sous_paillote
    OWNER TO postgres;


-- View: public.place_assise

-- DROP VIEW public.place_assise;

CREATE OR REPLACE VIEW public.place_assise
 AS
 SELECT mobiliers_eleves.code_etablissement,
    mobiliers_eleves.code_type_annee,
    sum(
        CASE
            WHEN mobiliers_eleves.code_type_mobilier_eleve = 5 THEN mobiliers_eleves.nbre_mobiliers_eleve * 1
            WHEN mobiliers_eleves.code_type_mobilier_eleve = 6 THEN mobiliers_eleves.nbre_mobiliers_eleve * 2
            WHEN mobiliers_eleves.code_type_mobilier_eleve = 7 THEN mobiliers_eleves.nbre_mobiliers_eleve * 3
            WHEN mobiliers_eleves.code_type_mobilier_eleve = 8 THEN mobiliers_eleves.nbre_mobiliers_eleve * 3
            WHEN mobiliers_eleves.code_type_mobilier_eleve = 9 THEN mobiliers_eleves.nbre_mobiliers_eleve * 4
            WHEN mobiliers_eleves.code_type_mobilier_eleve = 10 THEN mobiliers_eleves.nbre_mobiliers_eleve * 5
            WHEN mobiliers_eleves.code_type_mobilier_eleve = 11 THEN mobiliers_eleves.nbre_mobiliers_eleve * 6
            ELSE NULL::integer
        END) AS place_assises
   FROM mobiliers_eleves
  GROUP BY mobiliers_eleves.code_etablissement, mobiliers_eleves.code_type_annee;

ALTER TABLE public.place_assise
    OWNER TO postgres;


-- View: public.pop_3_5_ans

-- DROP VIEW public.pop_3_5_ans;

CREATE OR REPLACE VIEW public.pop_3_5_ans
 AS
 SELECT population.code_type_annee,
    population.code_regroupement,
    sum(population.population_garcons_scolarisable) AS pop_3_5_ans_g,
    sum(population.population_filles_scolarisable) AS pop_3_5_ans_f
   FROM population
  WHERE population.code_type_tranche_age = ANY (ARRAY[4, 5, 6])
  GROUP BY population.code_type_annee, population.code_regroupement;

ALTER TABLE public.pop_3_5_ans
    OWNER TO postgres;


-- View: public.pop_6_11_ans

-- DROP VIEW public.pop_6_11_ans;

CREATE OR REPLACE VIEW public.pop_6_11_ans
 AS
 SELECT population.code_type_annee,
    population.code_regroupement,
    sum(population.population_garcons_scolarisable) AS pop_6_11_ans_g,
    sum(population.population_filles_scolarisable) AS pop_6_11_ans_f
   FROM population
  WHERE population.code_type_tranche_age = ANY (ARRAY[7, 8, 9, 10, 11, 12])
  GROUP BY population.code_type_annee, population.code_regroupement;

ALTER TABLE public.pop_6_11_ans
    OWNER TO postgres;


-- View: public.pop_6_ans

-- DROP VIEW public.pop_6_ans;

CREATE OR REPLACE VIEW public.pop_6_ans
 AS
 SELECT population.code_type_annee,
    population.code_regroupement,
    sum(population.population_garcons_scolarisable) AS pop_6_ans_g,
    sum(population.population_filles_scolarisable) AS pop_6_ans_f
   FROM population
  WHERE population.code_type_tranche_age = 7
  GROUP BY population.code_type_annee, population.code_regroupement;

ALTER TABLE public.pop_6_ans
    OWNER TO postgres;


-- View: public.pop_11_ans

-- DROP VIEW public.pop_11_ans;

CREATE OR REPLACE VIEW public.pop_11_ans
 AS
 SELECT population.code_type_annee,
    population.code_regroupement,
    sum(population.population_garcons_scolarisable) AS pop_11_ans_g,
    sum(population.population_filles_scolarisable) AS pop_11_ans_f
   FROM population
  WHERE population.code_type_tranche_age = 12
  GROUP BY population.code_type_annee, population.code_regroupement;

ALTER TABLE public.pop_11_ans
    OWNER TO postgres;


-- View: public.pop_12_15_ans

-- DROP VIEW public.pop_12_15_ans;

CREATE OR REPLACE VIEW public.pop_12_15_ans
 AS
 SELECT population.code_type_annee,
    population.code_regroupement,
    sum(population.population_garcons_scolarisable) AS pop_12_15_ans_g,
    sum(population.population_filles_scolarisable) AS pop_12_15_ans_f
   FROM population
  WHERE population.code_type_tranche_age = ANY (ARRAY[13, 14, 15, 16])
  GROUP BY population.code_type_annee, population.code_regroupement;

ALTER TABLE public.pop_12_15_ans
    OWNER TO postgres;


-- View: public.pop_12_18_ans

-- DROP VIEW public.pop_12_18_ans;

CREATE OR REPLACE VIEW public.pop_12_18_ans
 AS
 SELECT population.code_type_annee,
    population.code_regroupement,
    sum(population.population_garcons_scolarisable) AS pop_12_18_ans_g,
    sum(population.population_filles_scolarisable) AS pop_12_18_ans_f
   FROM population
  WHERE population.code_type_tranche_age = ANY (ARRAY[13, 14, 15, 16, 17, 18, 19])
  GROUP BY population.code_type_annee, population.code_regroupement;

ALTER TABLE public.pop_12_18_ans
    OWNER TO postgres;


-- View: public.pop_12_ans

-- DROP VIEW public.pop_12_ans;

CREATE OR REPLACE VIEW public.pop_12_ans
 AS
 SELECT population.code_type_annee,
    population.code_regroupement,
    sum(population.population_garcons_scolarisable) AS pop_12_ans_g,
    sum(population.population_filles_scolarisable) AS pop_12_ans_f
   FROM population
  WHERE population.code_type_tranche_age = 13
  GROUP BY population.code_type_annee, population.code_regroupement;

ALTER TABLE public.pop_12_ans
    OWNER TO postgres;


-- View: public.pop_15_ans

-- DROP VIEW public.pop_15_ans;

CREATE OR REPLACE VIEW public.pop_15_ans
 AS
 SELECT population.code_type_annee,
    population.code_regroupement,
    sum(population.population_garcons_scolarisable) AS pop_15_ans_g,
    sum(population.population_filles_scolarisable) AS pop_15_ans_f
   FROM population
  WHERE population.code_type_tranche_age = 16
  GROUP BY population.code_type_annee, population.code_regroupement;

ALTER TABLE public.pop_15_ans
    OWNER TO postgres;


-- View: public.pop_16_18_ans

-- DROP VIEW public.pop_16_18_ans;

CREATE OR REPLACE VIEW public.pop_16_18_ans
 AS
 SELECT population.code_type_annee,
    population.code_regroupement,
    sum(population.population_garcons_scolarisable) AS pop_16_18_ans_g,
    sum(population.population_filles_scolarisable) AS pop_16_18_ans_f
   FROM population
  WHERE population.code_type_tranche_age = ANY (ARRAY[17, 18, 19])
  GROUP BY population.code_type_annee, population.code_regroupement;

ALTER TABLE public.pop_16_18_ans
    OWNER TO postgres;


-- View: public.pop_16_ans

-- DROP VIEW public.pop_16_ans;

CREATE OR REPLACE VIEW public.pop_16_ans
 AS
 SELECT population.code_type_annee,
    population.code_regroupement,
    sum(population.population_garcons_scolarisable) AS pop_16_ans_g,
    sum(population.population_filles_scolarisable) AS pop_16_ans_f
   FROM population
  WHERE population.code_type_tranche_age = 17
  GROUP BY population.code_type_annee, population.code_regroupement;

ALTER TABLE public.pop_16_ans
    OWNER TO postgres;


-- View: public.pop_18_ans

-- DROP VIEW public.pop_18_ans;

CREATE OR REPLACE VIEW public.pop_18_ans
 AS
 SELECT population.code_type_annee,
    population.code_regroupement,
    sum(population.population_garcons_scolarisable) AS pop_18_ans_g,
    sum(population.population_filles_scolarisable) AS pop_18_ans_f
   FROM population
  WHERE population.code_type_tranche_age = 19
  GROUP BY population.code_type_annee, population.code_regroupement;

ALTER TABLE public.pop_18_ans
    OWNER TO postgres;


-- View: public.prov_nb_eleve

-- DROP VIEW public.prov_nb_eleve;

CREATE OR REPLACE VIEW public.prov_nb_eleve
 AS
 SELECT 
    atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    sum(effectif_gp_par_age.inscrits_filles) AS prov_insc_f,
    sum(effectif_gp_par_age.inscrits_garcons) AS prov_insc_g
   FROM effectif_gp_par_age,
    atlas_admin
  WHERE effectif_gp_par_age.code_etablissement = atlas_admin.code_etablissement AND effectif_gp_par_age.code_type_annee = atlas_admin.code_type_annee
  GROUP BY atlas_admin.code_region, atlas_admin.region, atlas_admin.code_province, atlas_admin.province, atlas_admin.code_type_annee, atlas_admin.libelle_type_annee, atlas_admin.code_systeme_enseignement, atlas_admin.systeme_enseignement;

ALTER TABLE public.prov_nb_eleve
    OWNER TO postgres;


-- View: public.prov_nb_eleve_6_11_ans

-- DROP VIEW public.prov_nb_eleve_6_11_ans;

CREATE OR REPLACE VIEW public.prov_nb_eleve_6_11_ans
 AS
 SELECT atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_region,
    atlas_admin.region,
    sum(effectif_gp_par_age.inscrits_garcons) AS prov_insc_g_6_11,
    sum(effectif_gp_par_age.inscrits_filles) AS prov_insc_f_6_11
   FROM effectif_gp_par_age,
    atlas_admin
  WHERE effectif_gp_par_age.code_etablissement = atlas_admin.code_etablissement AND effectif_gp_par_age.code_type_annee = atlas_admin.code_type_annee AND (effectif_gp_par_age.code_type_age = ANY (ARRAY[4, 5, 6, 7, 8, 9]))
  GROUP BY atlas_admin.code_region, atlas_admin.region, atlas_admin.code_province, atlas_admin.province, atlas_admin.libelle_type_annee, atlas_admin.code_type_annee;

ALTER TABLE public.prov_nb_eleve_6_11_ans
    OWNER TO postgres;


-- View: public.prov_nb_eleve_12_15_ans

-- DROP VIEW public.prov_nb_eleve_12_15_ans;

CREATE OR REPLACE VIEW public.prov_nb_eleve_12_15_ans
 AS
 SELECT atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    sum(effectif_gp_par_age.inscrits_garcons) AS insc_g_12_15,
    sum(effectif_gp_par_age.inscrits_filles) AS insc_f_12_15
   FROM effectif_gp_par_age,
    atlas_admin
  WHERE effectif_gp_par_age.code_etablissement = atlas_admin.code_etablissement AND effectif_gp_par_age.code_type_annee = atlas_admin.code_type_annee AND (effectif_gp_par_age.code_type_age = ANY (ARRAY[13, 14, 15, 16]))
  GROUP BY atlas_admin.code_region, atlas_admin.region, atlas_admin.code_province, atlas_admin.province, atlas_admin.libelle_type_annee, atlas_admin.code_type_annee;

ALTER TABLE public.prov_nb_eleve_12_15_ans
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


-- View: public.prov_nouveau_inscrits

-- DROP VIEW public.prov_nouveau_inscrits;

CREATE OR REPLACE VIEW public.prov_nouveau_inscrits
 AS
 SELECT atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    nouveaux_inscrits.code_type_niveau,
    sum(nouveaux_inscrits.nouveaux_inscrits_garcons) AS prov_nvx_insc_g,
    sum(nouveaux_inscrits.nouveaux_inscrits_filles) AS prov_nvx_insc_f,
    atlas_admin.code_region,
    atlas_admin.region
   FROM nouveaux_inscrits,
    atlas_admin
  WHERE nouveaux_inscrits.code_etablissement = atlas_admin.code_etablissement AND nouveaux_inscrits.code_type_annee = atlas_admin.code_type_annee
  GROUP BY atlas_admin.code_province, atlas_admin.province, atlas_admin.code_type_annee, atlas_admin.libelle_type_annee, nouveaux_inscrits.code_type_niveau, atlas_admin.code_region, atlas_admin.region;

ALTER TABLE public.prov_nouveau_inscrits
    OWNER TO postgres;


-- View: public.prov_nv_eleve_red_niveau

-- DROP VIEW public.prov_nv_eleve_red_niveau;

CREATE OR REPLACE VIEW public.prov_nv_eleve_red_niveau
 AS
 SELECT atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    groupe_pedagogique.code_type_niveau,
    sum(effectif_gp.inscrit_g_gp) AS prov_inscrit_g,
    sum(effectif_gp.inscrit_f_gp) AS prov_inscrit_f,
    sum(groupe_pedagogique.redoublants_garcons) AS prov_redouble_g,
    sum(groupe_pedagogique.redoublants_filles) AS prov_redouble_f
   FROM effectif_gp,
    groupe_pedagogique,
    atlas_admin
  WHERE effectif_gp.code_etablissement = groupe_pedagogique.code_etablissement AND effectif_gp.code_type_annee = groupe_pedagogique.code_type_annee AND effectif_gp.numero_ordre_groupe = groupe_pedagogique.numero_ordre_groupe AND groupe_pedagogique.code_etablissement = atlas_admin.code_etablissement AND groupe_pedagogique.code_type_annee = atlas_admin.code_type_annee
  GROUP BY atlas_admin.code_province, atlas_admin.province, atlas_admin.code_type_annee, atlas_admin.libelle_type_annee, atlas_admin.code_region, atlas_admin.region, groupe_pedagogique.code_type_niveau;

ALTER TABLE public.prov_nv_eleve_red_niveau
    OWNER TO postgres;

                --Vue Finale--

-- View: public._vue_effectifs_eleves

-- DROP VIEW public._vue_effectifs_eleves;

CREATE OR REPLACE VIEW public._vue_effectifs_eleves
 AS
 SELECT atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_reconnaissance,
    atlas_admin.libelle_type_promoteur,
    atlas_admin.libelle_type_sociologique,
    atlas_admin.libelle_type_recrutement,
    atlas_admin.libelle_type_cpaf,
    atlas_admin.libelle_type_approche,
    atlas_admin.libelle_type_lieu_alphabetisation,
    atlas_admin.libelle_type_formule,
    atlas_admin.libelle_type_operateur,
    atlas_admin.libelle_type_financement,
    atlas_admin.libelle_type_langue,
    atlas_admin.libelle_type_formalite,
    effectif_gp_par_age.code_type_age,
    effectif_gp_par_age.inscrits_garcons,
    effectif_gp_par_age.inscrits_filles,
    effectif_gp_par_age.evalues_reg_insc_garcons,
    effectif_gp_par_age.evalues_reg_insc_filles,
    effectif_gp_par_age.evalues_libres_garcons,
    effectif_gp_par_age.evalues_libres_filles,
    effectif_gp_par_age.admis_reg_insc_garcons,
    effectif_gp_par_age.admis_reg_insc_filles,
    effectif_gp_par_age.admis_total_garcons,
    effectif_gp_par_age.admis_total_filles,
    effectif_gp_par_age.abandons_garcons,
    effectif_gp_par_age.abandons_filles,
    effectif_gp_par_age.numero_local,
    effectif_gp_par_age.g_premiere_insc,
    effectif_gp_par_age.f_premiere_insc,
    effectif_gp_par_age.total_premiere_insc,
    type_niveau.libelle_type_niveau,
    type_niveau.ordre_type_niveau,
    type_age.libelle_type_age,
    type_age.ordre_type_age,
    COALESCE(effectif_gp_par_age.inscrits_garcons, 0) + COALESCE(effectif_gp_par_age.inscrits_filles, 0) AS total_effectif,
    atlas_admin.systeme_enseignement_regroup,
    atlas_admin.statut_etablisement_prescolaire,
    type_serie.libelle_type_serie,
    type_cycle.libelle_type_cycle,
    type_filiere.libelle_type_filiere
   FROM atlas_admin,
    effectif_gp_par_age,
    type_age,
    type_niveau,
    groupe_pedagogique
     LEFT JOIN type_serie ON groupe_pedagogique.code_type_serie = type_serie.code_type_serie
     LEFT JOIN type_cycle ON groupe_pedagogique.code_type_cycle = type_cycle.code_type_cycle
     LEFT JOIN type_filiere ON groupe_pedagogique.code_type_filiere = type_filiere.code_type_filiere
  WHERE groupe_pedagogique.code_etablissement = atlas_admin.code_etablissement AND groupe_pedagogique.code_type_annee = atlas_admin.code_type_annee AND groupe_pedagogique.numero_ordre_groupe = effectif_gp_par_age.numero_ordre_groupe AND groupe_pedagogique.code_etablissement = effectif_gp_par_age.code_etablissement AND groupe_pedagogique.code_type_annee = effectif_gp_par_age.code_type_annee AND groupe_pedagogique.code_type_niveau = type_niveau.code_type_niveau AND effectif_gp_par_age.code_type_age = type_age.code_type_age;

ALTER TABLE public._vue_effectifs_eleves
    OWNER TO postgres;


-- View: public._vue_effectif_eleve_dist_parcouru

-- DROP VIEW public._vue_effectif_eleve_dist_parcouru;

CREATE OR REPLACE VIEW public._vue_effectif_eleve_dist_parcouru
 AS
 SELECT atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_sociologique,
    type_niveau.libelle_type_niveau,
    type_niveau.ordre_type_niveau,
    type_distance.libelle_type_distance,
    type_distance.ordre_type_distance,
    effectifs_distance_etab.distance_garcons,
    effectifs_distance_etab.distances_filles,
        CASE
            WHEN type_distance.libelle_type_distance::text = '< 1 km'::text THEN '< 1 km'::text
            WHEN type_distance.libelle_type_distance::text = '1 - 2 km'::text OR type_distance.libelle_type_distance::text = '2 - 3 km'::text THEN '1 à 3 km'::text
            WHEN type_distance.libelle_type_distance::text = '4 - 5 km'::text THEN '4 à 5 km'::text
            WHEN type_distance.libelle_type_distance::text = '> 5 km'::text THEN '> 5 km'::text
            ELSE 'Indeterminé'::text
        END AS type_distance_prescolaire,
    atlas_admin.systeme_enseignement_regroup,
    atlas_admin.statut_etablisement_prescolaire,
    atlas_admin.libelle_type_formalite
   FROM effectifs_distance_etab,
    atlas_admin,
    type_distance,
    type_niveau
  WHERE effectifs_distance_etab.code_etablissement = atlas_admin.code_etablissement AND effectifs_distance_etab.code_type_annee = atlas_admin.code_type_annee AND effectifs_distance_etab.code_type_distance = type_distance.code_type_distance AND effectifs_distance_etab.code_type_niveau = type_niveau.code_type_niveau;

ALTER TABLE public._vue_effectif_eleve_dist_parcouru
    OWNER TO postgres;


-- View: public._vue_effectif_eleve_handicape

-- DROP VIEW public._vue_effectif_eleve_handicape;

CREATE OR REPLACE VIEW public._vue_effectif_eleve_handicape
 AS
 SELECT atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_reconnaissance,
    atlas_admin.libelle_type_promoteur,
    atlas_admin.libelle_type_sociologique,
    atlas_admin.libelle_type_recrutement,
    atlas_admin.libelle_type_cpaf,
    atlas_admin.libelle_type_approche,
    atlas_admin.libelle_type_lieu_alphabetisation,
    atlas_admin.libelle_type_formule,
    atlas_admin.libelle_type_operateur,
    atlas_admin.libelle_type_financement,
    atlas_admin.libelle_type_langue,
    atlas_admin.libelle_type_formalite,
    atlas_admin.systeme_enseignement_regroup,
    atlas_admin.statut_etablisement_prescolaire,
    effectifs_handicapes.handicapes_hommes,
    effectifs_handicapes.handicapes_femmes,
    type_handicap.libelle_type_handicap,
    type_handicap.ordre_type_handicap,
    type_serie.libelle_type_serie,
    type_cycle.libelle_type_cycle,
    type_filiere.libelle_type_filiere
   FROM atlas_admin,
    effectifs_handicapes,
    type_handicap,
    groupe_pedagogique
     LEFT JOIN type_serie ON groupe_pedagogique.code_type_serie = type_serie.code_type_serie
     LEFT JOIN type_cycle ON groupe_pedagogique.code_type_cycle = type_cycle.code_type_cycle
     LEFT JOIN type_filiere ON groupe_pedagogique.code_type_filiere = type_filiere.code_type_filiere
  WHERE groupe_pedagogique.code_etablissement = atlas_admin.code_etablissement AND groupe_pedagogique.code_type_annee = atlas_admin.code_type_annee AND effectifs_handicapes.code_type_handicap = type_handicap.code_type_handicap AND atlas_admin.code_etablissement = effectifs_handicapes.code_etablissement AND atlas_admin.code_type_annee = effectifs_handicapes.code_type_annee AND groupe_pedagogique.code_type_niveau = effectifs_handicapes.code_type_niveau AND groupe_pedagogique.code_etablissement = effectifs_handicapes.code_etablissement AND groupe_pedagogique.code_type_annee = effectifs_handicapes.code_type_annee;

ALTER TABLE public._vue_effectif_eleve_handicape
    OWNER TO postgres;


-- View: public._vue_effectif_eleve_nationalite

-- DROP VIEW public._vue_effectif_eleve_nationalite;

CREATE OR REPLACE VIEW public._vue_effectif_eleve_nationalite
 AS
 SELECT atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_reconnaissance,
    atlas_admin.libelle_type_promoteur,
    atlas_admin.libelle_type_sociologique,
    atlas_admin.libelle_type_recrutement,
    atlas_admin.libelle_type_cpaf,
    atlas_admin.libelle_type_approche,
    atlas_admin.libelle_type_lieu_alphabetisation,
    atlas_admin.libelle_type_formule,
    atlas_admin.libelle_type_operateur,
    atlas_admin.libelle_type_financement,
    atlas_admin.libelle_type_langue,
    atlas_admin.libelle_type_formalite,
    atlas_admin.systeme_enseignement_regroup,
    atlas_admin.statut_etablisement_prescolaire,
    effectif_gp_nationalite.garcons_nationalite,
    effectif_gp_nationalite.filles_nationalite,
    type_nationalite.libelle_type_nationalite,
    type_serie.libelle_type_serie,
    type_cycle.libelle_type_cycle,
    type_filiere.libelle_type_filiere
   FROM atlas_admin,
    effectif_gp_nationalite,
    type_nationalite,
    groupe_pedagogique
     LEFT JOIN type_serie ON groupe_pedagogique.code_type_serie = type_serie.code_type_serie
     LEFT JOIN type_cycle ON groupe_pedagogique.code_type_cycle = type_cycle.code_type_cycle
     LEFT JOIN type_filiere ON groupe_pedagogique.code_type_filiere = type_filiere.code_type_filiere
  WHERE groupe_pedagogique.code_etablissement = atlas_admin.code_etablissement AND effectif_gp_nationalite.code_type_nationalite = effectif_gp_nationalite.code_type_nationalite AND groupe_pedagogique.code_type_annee = atlas_admin.code_type_annee AND groupe_pedagogique.numero_ordre_groupe = effectif_gp_nationalite.numero_ordre_groupe AND groupe_pedagogique.code_etablissement = effectif_gp_nationalite.code_etablissement AND groupe_pedagogique.code_type_annee = effectif_gp_nationalite.code_type_annee;

ALTER TABLE public._vue_effectif_eleve_nationalite
    OWNER TO postgres;


-- View: public._vue_effectif_nvx_insc_cp1_presco

-- DROP VIEW public._vue_effectif_nvx_insc_cp1_presco;

CREATE OR REPLACE VIEW public._vue_effectif_nvx_insc_cp1_presco
 AS
 SELECT atlas_admin.code_type_annee,
    etab_nouveaux_inscrits_cp1.code_etablissement,
    atlas_admin.region,
    atlas_admin.province,
    atlas_admin.commune,
    atlas_admin.nom_etablissement,
    atlas_admin.systeme_enseignement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.systeme_enseignement_regroup,
    atlas_admin.statut_etablisement_prescolaire,
    atlas_admin.libelle_type_sociologique,
    etab_nouveaux_inscrits_cp1.nvx_insc_g_etab,
    etab_nouveaux_inscrits_cp1.nvx_insc_f_etab,
    etab_nouveaux_inscrits_prescolaire.presc_insc_g,
    etab_nouveaux_inscrits_prescolaire.presc_inc_f
   FROM atlas_admin
     LEFT JOIN etab_nouveaux_inscrits_prescolaire ON atlas_admin.code_etablissement = etab_nouveaux_inscrits_prescolaire.code_etablissement AND atlas_admin.code_type_annee = etab_nouveaux_inscrits_prescolaire.code_type_annee
     LEFT JOIN etab_nouveaux_inscrits_cp1 ON atlas_admin.code_etablissement = etab_nouveaux_inscrits_cp1.code_etablissement AND atlas_admin.code_type_annee = etab_nouveaux_inscrits_cp1.code_type_annee
     LEFT JOIN etab_nouveaux_inscrits_prescolaire etab_nouveaux_inscrits_prescolaire_1 ON atlas_admin.code_type_annee = etab_nouveaux_inscrits_prescolaire_1.code_type_annee AND atlas_admin.code_etablissement = etab_nouveaux_inscrits_prescolaire_1.code_etablissement
  WHERE atlas_admin.code_systeme_enseignement = 2;

ALTER TABLE public._vue_effectif_nvx_insc_cp1_presco
    OWNER TO postgres;


-- View: public._vue_effectif_nvx_insc_par_age

-- DROP VIEW public._vue_effectif_nvx_insc_par_age;

CREATE OR REPLACE VIEW public._vue_effectif_nvx_insc_par_age
 AS
 SELECT atlas_admin.region,
    atlas_admin.province,
    atlas_admin.commune,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.systeme_enseignement,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_sociologique,
    atlas_admin.systeme_enseignement_regroup,
    atlas_admin.statut_etablisement_prescolaire,
    type_niveau.libelle_type_niveau,
    type_age.libelle_type_age,
    nouveaux_inscrits.nouveaux_inscrits_garcons,
    nouveaux_inscrits.nouveaux_inscrits_filles
   FROM type_age,
    nouveaux_inscrits,
    atlas_admin,
    type_niveau
  WHERE type_age.code_type_age = nouveaux_inscrits.code_type_age AND nouveaux_inscrits.code_etablissement = atlas_admin.code_etablissement AND nouveaux_inscrits.code_type_annee = atlas_admin.code_type_annee AND nouveaux_inscrits.code_type_niveau = type_niveau.code_type_niveau;

ALTER TABLE public._vue_effectif_nvx_insc_par_age
    OWNER TO postgres;


-- View: public._vue_effectif_par_profession_parent

-- DROP VIEW public._vue_effectif_par_profession_parent;

CREATE OR REPLACE VIEW public._vue_effectif_par_profession_parent
 AS
 SELECT atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    effectif_gp_par_profession.code_type_profession,
    type_profession.libelle_type_profession,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_sociologique,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    sum(effectif_gp_par_profession.garcon_profession) AS profession_g,
    sum(effectif_gp_par_profession.filles_profession) AS profession_f,
    atlas_admin.systeme_enseignement_regroup,
    atlas_admin.statut_etablisement_prescolaire,
    atlas_admin.libelle_type_formalite,
    type_serie.libelle_type_serie,
    type_cycle.libelle_type_cycle,
    type_filiere.libelle_type_filiere
   FROM effectif_gp_par_profession,
    type_profession,
    atlas_admin,
    groupe_pedagogique
     LEFT JOIN type_serie ON groupe_pedagogique.code_type_serie = type_serie.code_type_serie
     LEFT JOIN type_cycle ON groupe_pedagogique.code_type_cycle = type_cycle.code_type_cycle
     LEFT JOIN type_filiere ON groupe_pedagogique.code_type_filiere = type_filiere.code_type_filiere
  WHERE effectif_gp_par_profession.code_type_profession = type_profession.code_type_profession AND groupe_pedagogique.code_etablissement = atlas_admin.code_etablissement AND groupe_pedagogique.code_type_annee = atlas_admin.code_type_annee AND groupe_pedagogique.numero_ordre_groupe = effectif_gp_par_profession.numero_ordre_groupe AND groupe_pedagogique.code_etablissement = effectif_gp_par_profession.code_etablissement AND groupe_pedagogique.code_type_annee = effectif_gp_par_profession.code_type_annee
  GROUP BY atlas_admin.code_region, atlas_admin.region, atlas_admin.code_province, atlas_admin.province, atlas_admin.code_commune, atlas_admin.commune, atlas_admin.code_type_annee, atlas_admin.libelle_type_annee, type_profession.libelle_type_profession, effectif_gp_par_profession.code_type_profession, atlas_admin.code_etablissement, atlas_admin.nom_etablissement, atlas_admin.statut_etablisement_regroup, atlas_admin.libelle_type_sociologique, atlas_admin.libelle_type_statut_etablissement, atlas_admin.libelle_type_etablissement, atlas_admin.code_systeme_enseignement, atlas_admin.systeme_enseignement, atlas_admin.systeme_enseignement_regroup, atlas_admin.statut_etablisement_prescolaire, atlas_admin.libelle_type_formalite, type_serie.libelle_type_serie, type_cycle.libelle_type_cycle, type_filiere.libelle_type_filiere;

ALTER TABLE public._vue_effectif_par_profession_parent
    OWNER TO postgres;


-- View: public._vue_enseignant_age_experience_pro

-- DROP VIEW public._vue_enseignant_age_experience_pro;

CREATE OR REPLACE VIEW public._vue_enseignant_age_experience_pro
 AS
 SELECT atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.nom_etablissement,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_sociologique,
    type_sexe.libelle_type_sexe,
    type_sexe.ordre_type_sexe,
    type_emploi.libelle_type_emploi,
    type_emploi.ordre_type_emploi,
    type_diplome_academique.libelle_type_diplome_academique,
    type_diplome_academique.ordre_type_diplome_academique,
    type_diplome_professionnel.libelle_type_diplome_professionnel,
    type_diplome_professionnel.ordre_type_diplome_professionnel,
    type_fonction.libelle_type_fonction,
    type_fonction.ordre_type_fonction,
    enseignant_age_experience_pro.tranche_age_enseignant,
    enseignant_age_experience_pro.ordre_tranche_age_enseignant,
    enseignant_age_experience_pro.experience_enseignant,
    enseignant_age_experience_pro.ordre_experience_enseignant,
    atlas_admin.systeme_enseignement_regroup,
    atlas_admin.statut_etablisement_prescolaire,
    atlas_admin.libelle_type_formalite,
    enseignant_age_experience_pro.tranche_age_enseignant_prescolaire,
    enseignant_age_experience_pro.ordre_tranche_age_enseignant_prescolaire,
    enseignant_age_experience_pro.experience_enseignant_prescolaire,
    enseignant_age_experience_pro.ordre_experience_enseignant_prescolaire,
    enseignant_age_experience_pro.diplome_enseignant_prescolaire,
    enseignant_age_experience_pro.ordre_diplome_enseignant_prescolaire
   FROM atlas_admin,
    enseignant_age_experience_pro
     LEFT JOIN type_sexe ON enseignant_age_experience_pro.code_type_sexe = type_sexe.code_type_sexe
     LEFT JOIN type_emploi ON enseignant_age_experience_pro.code_type_emploi = type_emploi.code_type_emploi
     LEFT JOIN type_fonction ON enseignant_age_experience_pro.code_type_fonction = type_fonction.code_type_fonction
     LEFT JOIN type_diplome_academique ON enseignant_age_experience_pro.code_type_diplome_academique = type_diplome_academique.code_type_diplome_academique
     LEFT JOIN type_diplome_professionnel ON enseignant_age_experience_pro.code_type_diplome_professionnel = type_diplome_professionnel.code_type_diplome_professionnel
  WHERE enseignant_age_experience_pro.code_etablissement = atlas_admin.code_etablissement AND enseignant_age_experience_pro.code_type_annee = atlas_admin.code_type_annee;

ALTER TABLE public._vue_enseignant_age_experience_pro
    OWNER TO postgres;


-- View: public._vue_enseignant_gp

-- DROP VIEW public._vue_enseignant_gp;

CREATE OR REPLACE VIEW public._vue_enseignant_gp
 AS
 SELECT atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_sociologique,
    type_niveau.libelle_type_niveau,
    type_niveau.ordre_type_niveau,
    type_groupe_pedagogique.libelle_type_groupe_pedagogique,
    type_groupe_pedagogique.ordre_type_groupe_pedagogique,
    count(enseignant_groupe_pedagogique.identifiant_enseignant) AS nb_enseignant_charge_cours
   FROM enseignant_groupe_pedagogique,
    groupe_pedagogique,
    atlas_admin,
    type_groupe_pedagogique,
    type_niveau
  WHERE enseignant_groupe_pedagogique.code_etablissement = groupe_pedagogique.code_etablissement AND enseignant_groupe_pedagogique.code_type_annee = groupe_pedagogique.code_type_annee AND enseignant_groupe_pedagogique.numero_ordre_groupe = groupe_pedagogique.numero_ordre_groupe AND enseignant_groupe_pedagogique.code_etablissement = atlas_admin.code_etablissement AND enseignant_groupe_pedagogique.code_type_annee = atlas_admin.code_type_annee AND groupe_pedagogique.code_type_groupe_pedagogique = type_groupe_pedagogique.code_type_groupe_pedagogique AND groupe_pedagogique.code_type_niveau = type_niveau.code_type_niveau
  GROUP BY atlas_admin.code_region, atlas_admin.region, atlas_admin.code_province, atlas_admin.province, atlas_admin.code_commune, atlas_admin.commune, atlas_admin.code_etablissement, atlas_admin.nom_etablissement, atlas_admin.code_systeme_enseignement, atlas_admin.systeme_enseignement, atlas_admin.code_type_annee, atlas_admin.libelle_type_annee, atlas_admin.libelle_type_etablissement, atlas_admin.libelle_type_statut_etablissement, atlas_admin.statut_etablisement_regroup, atlas_admin.libelle_type_sociologique, type_niveau.libelle_type_niveau, type_niveau.ordre_type_niveau, type_groupe_pedagogique.libelle_type_groupe_pedagogique, type_groupe_pedagogique.ordre_type_groupe_pedagogique;

ALTER TABLE public._vue_enseignant_gp
    OWNER TO postgres;


-- View: public._vue_equipement_didactique

-- DROP VIEW public._vue_equipement_didactique;

CREATE OR REPLACE VIEW public._vue_equipement_didactique
 AS
 SELECT atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_sociologique,
    type_equipement_didactique.libelle_type_equipement_didactique,
    type_equipement_didactique.ordre_type_equipement_didactique,
    equipement_didactique_etab.nbre_equip_didact
   FROM atlas_admin,
    equipement_didactique_etab,
    type_equipement_didactique
  WHERE atlas_admin.code_etablissement = equipement_didactique_etab.code_etablissement AND atlas_admin.code_type_annee = equipement_didactique_etab.code_type_annee AND equipement_didactique_etab.code_type_equipement_didactique = type_equipement_didactique.code_type_equipement_didactique;

ALTER TABLE public._vue_equipement_didactique
    OWNER TO postgres;

-- View: public._vue_local_caracteristique_etat

-- DROP VIEW public._vue_local_caracteristique_etat;

CREATE OR REPLACE VIEW public._vue_local_caracteristique_etat
 AS
 SELECT atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_sociologique,
    local.numero_local,
    local.annee_mise_service,
    local.surface_local,
    local.nbre_places_assises,
    local.num_ordre,
    type_nature_porte.libelle_type_nature_porte,
    type_nature_porte.ordre_type_nature_porte,
    type_nature_mur.libelle_type_nature_mur,
    type_nature_mur.ordre_type_nature_mur,
    type_nature_sol.libelle_type_nature_sol,
    type_nature_sol.ordre_type_nature_sol,
    type_nature_fenetre.libelle_type_nature_fenetre,
    type_nature_fenetre.ordre_type_nature_fenetre,
    type_nature_toit.libelle_type_nature_toit,
    type_nature_toit.ordre_type_nature_toit,
    type_local.libelle_type_local,
    type_local.ordre_type_local,
    type_appreciation_etat_1.libelle_type_appreciation_etat AS etat_mur,
    type_appreciation_etat_1.ordre_type_appreciation_etat AS ordre_etat_mur,
    type_appreciation_etat_5.libelle_type_appreciation_etat AS etat_toit,
    type_appreciation_etat_5.ordre_type_appreciation_etat AS ordre_etat_toit,
    type_appreciation_etat_6.libelle_type_appreciation_etat AS etat_sol,
    type_appreciation_etat_6.ordre_type_appreciation_etat AS ordre_etat_sol,
    type_appreciation_etat_4.libelle_type_appreciation_etat AS etat_ouverture,
    type_appreciation_etat_4.ordre_type_appreciation_etat AS ordre_etat_ouverture,
    type_appreciation_etat.libelle_type_appreciation_etat AS etat_installation_electrique,
    type_appreciation_etat.ordre_type_appreciation_etat AS ordre_etat_electrique,
    type_appreciation_etat_3.libelle_type_appreciation_etat AS etat_fermeture_protection,
    type_appreciation_etat_3.ordre_type_appreciation_etat AS ordre_etat_fermeture_protection,
    type_appreciation_etat_2.libelle_type_appreciation_etat AS etat_fenetre,
    type_appreciation_etat_2.ordre_type_appreciation_etat AS ordre_etat_fenetre,
        CASE local.annee_mise_service IS NOT NULL
            WHEN local.annee_mise_service < 1960 THEN '<1960'::text
            WHEN local.annee_mise_service <= 1970 THEN '1960-1970'::text
            WHEN local.annee_mise_service <= 1980 THEN '1971-1980'::text
            WHEN local.annee_mise_service <= 1990 THEN '1981-1990'::text
            WHEN local.annee_mise_service <= 2000 THEN '1991-2000'::text
            WHEN local.annee_mise_service <= 2010 THEN '2011-2020'::text
            WHEN local.annee_mise_service > 2020 THEN '>2020'::text
            ELSE NULL::text
        END AS tranche_annee_mise_service,
        CASE local.surface_local IS NOT NULL
            WHEN local.surface_local < 40 THEN '<40m²'::text
            WHEN local.surface_local <= 50 THEN '40-50m²'::text
            WHEN local.surface_local <= 60 THEN '51-60m²'::text
            WHEN local.surface_local <= 70 THEN '61-70m²'::text
            WHEN local.surface_local > 70 THEN '>70m²'::text
            ELSE 'indeterminée'::text
        END AS tranche_surface_local,
        CASE local.surface_local IS NOT NULL
            WHEN local.surface_local < 40 THEN '<40m²'::text
            WHEN local.surface_local < 50 THEN '40-49m²'::text
            WHEN local.surface_local < 60 THEN '50-59m²'::text
            WHEN local.surface_local >= 60 THEN '>60m²'::text
            ELSE 'indeterminée'::text
        END AS tranche_surface_local_prescolaire,
    atlas_admin.systeme_enseignement_regroup,
    atlas_admin.statut_etablisement_prescolaire,
    atlas_admin.libelle_type_formalite
   FROM atlas_admin,
    local
     LEFT JOIN type_appreciation_etat type_appreciation_etat_2 ON local.etat_fenetre = type_appreciation_etat_2.code_type_appreciation_etat
     LEFT JOIN type_appreciation_etat type_appreciation_etat_3 ON local.etat_fermeture_protection = type_appreciation_etat_3.code_type_appreciation_etat
     LEFT JOIN type_appreciation_etat ON local.etat_installation_electrique = type_appreciation_etat.code_type_appreciation_etat
     LEFT JOIN type_appreciation_etat type_appreciation_etat_4 ON local.etat_ouverture = type_appreciation_etat_4.code_type_appreciation_etat
     LEFT JOIN type_appreciation_etat type_appreciation_etat_6 ON local.etat_sol = type_appreciation_etat_6.code_type_appreciation_etat
     LEFT JOIN type_appreciation_etat type_appreciation_etat_5 ON local.etat_toit = type_appreciation_etat_5.code_type_appreciation_etat
     LEFT JOIN type_appreciation_etat type_appreciation_etat_1 ON local.etat_mur = type_appreciation_etat_1.code_type_appreciation_etat
     LEFT JOIN type_local ON local.code_type_local = type_local.code_type_local
     LEFT JOIN type_nature_toit ON local.code_type_nature_toit = type_nature_toit.code_type_nature_toit
     LEFT JOIN type_nature_fenetre ON local.code_type_nature_fenetre = type_nature_fenetre.code_type_nature_fenetre
     LEFT JOIN type_nature_porte ON local.code_type_nature_porte = type_nature_porte.code_type_nature_porte
     LEFT JOIN type_nature_mur ON local.code_type_nature_mur = type_nature_mur.code_type_nature_mur
     LEFT JOIN type_nature_sol ON local.code_type_nature_sol = type_nature_sol.code_type_nature_sol
  WHERE local.code_etablissement = atlas_admin.code_etablissement AND local.code_type_annee = atlas_admin.code_type_annee;

ALTER TABLE public._vue_local_caracteristique_etat
    OWNER TO postgres;

-- View: public._vue_local_financement

-- DROP VIEW public._vue_local_financement;

CREATE OR REPLACE VIEW public._vue_local_financement
 AS
 SELECT atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_sociologique,
    type_local.libelle_type_local,
    type_local.ordre_type_local,
    type_financement.libelle_type_financement,
    type_financement.ordre_type_financement,
    local_financement.numero_local,
    atlas_admin.systeme_enseignement_regroup,
    atlas_admin.statut_etablisement_prescolaire,
    atlas_admin.libelle_type_formalite
   FROM type_financement,
    atlas_admin,
    local_financement,
    type_local
     RIGHT JOIN local ON type_local.code_type_local = local.code_type_local
  WHERE type_financement.code_type_financement = local_financement.code_type_financement AND atlas_admin.code_type_annee = local.code_type_annee AND atlas_admin.code_etablissement = local.code_etablissement AND local.code_type_annee = local_financement.code_type_annee AND local.code_etablissement = local_financement.code_etablissement AND local.numero_local = local_financement.numero_local;

ALTER TABLE public._vue_local_financement
    OWNER TO postgres;

-- View: public._vue_manuels_eleves

-- DROP VIEW public._vue_manuels_eleves;

CREATE OR REPLACE VIEW public._vue_manuels_eleves
 AS
 SELECT atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_sociologique,
    type_manuel_eleve.libelle_type_manuel_eleve,
    type_manuel_eleve.ordre_type_manuel_eleve,
    type_niveau.libelle_type_niveau,
    type_niveau.ordre_type_niveau,
    manuels_eleves.nbre_manuels_eleve,
    manuels_eleves.nbre_manuels_propre_eleve
   FROM atlas_admin,
    manuels_eleves,
    type_manuel_eleve,
    type_niveau
  WHERE atlas_admin.code_etablissement = manuels_eleves.code_etablissement AND atlas_admin.code_type_annee = manuels_eleves.code_type_annee AND manuels_eleves.code_type_manuel_eleve = type_manuel_eleve.code_type_manuel_eleve AND manuels_eleves.code_type_niveau = type_niveau.code_type_niveau;

ALTER TABLE public._vue_manuels_eleves
    OWNER TO postgres;

-- View: public._vue_manuels_enseignants

-- DROP VIEW public._vue_manuels_enseignants;

CREATE OR REPLACE VIEW public._vue_manuels_enseignants
 AS
 SELECT atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_sociologique,
    type_manuel_eleve.libelle_type_manuel_eleve,
    type_manuel_eleve.ordre_type_manuel_eleve,
    type_niveau.libelle_type_niveau,
    type_niveau.ordre_type_niveau,
    guides_pedagogiques_niveau.nbre_guides_pedagogique
   FROM atlas_admin,
    guides_pedagogiques_niveau,
    type_manuel_eleve,
    type_niveau
  WHERE atlas_admin.code_type_annee = guides_pedagogiques_niveau.code_type_annee AND atlas_admin.code_etablissement = guides_pedagogiques_niveau.code_etablissement AND guides_pedagogiques_niveau.code_type_manuel_eleve = type_manuel_eleve.code_type_manuel_eleve AND guides_pedagogiques_niveau.code_type_niveau = type_niveau.code_type_niveau;

ALTER TABLE public._vue_manuels_enseignants
    OWNER TO postgres;

-- View: public._vue_mobilier_collectif

-- DROP VIEW public._vue_mobilier_collectif;

CREATE OR REPLACE VIEW public._vue_mobilier_collectif
 AS
 SELECT atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_sociologique,
    type_mobilier_collectif.libelle_type_mobilier_collectif,
    type_mobilier_collectif.ordre_type_mobilier_collectif,
    type_niveau.libelle_type_niveau,
    type_niveau.ordre_type_niveau,
    sum(mobiliers_collectifs.nbre_mobiliers_collectif) AS nb_mobilier_collectif
   FROM mobiliers_collectifs,
    type_mobilier_collectif,
    atlas_admin,
    type_niveau
  WHERE mobiliers_collectifs.code_type_mobilier_collectif = type_mobilier_collectif.code_type_mobilier_collectif AND mobiliers_collectifs.code_etablissement = atlas_admin.code_etablissement AND mobiliers_collectifs.code_type_annee = atlas_admin.code_type_annee AND mobiliers_collectifs.code_type_niveau = type_niveau.code_type_niveau
  GROUP BY atlas_admin.code_region, atlas_admin.region, atlas_admin.code_province, atlas_admin.province, atlas_admin.code_commune, atlas_admin.commune, atlas_admin.code_etablissement, atlas_admin.nom_etablissement, atlas_admin.code_systeme_enseignement, atlas_admin.systeme_enseignement, atlas_admin.code_type_annee, atlas_admin.libelle_type_annee, atlas_admin.libelle_type_etablissement, atlas_admin.libelle_type_statut_etablissement, atlas_admin.statut_etablisement_regroup, atlas_admin.libelle_type_sociologique, type_mobilier_collectif.libelle_type_mobilier_collectif, type_mobilier_collectif.ordre_type_mobilier_collectif, type_niveau.libelle_type_niveau, type_niveau.ordre_type_niveau;

ALTER TABLE public._vue_mobilier_collectif
    OWNER TO postgres;

-- View: public._vue_nb_eleve_groupe_pedagogique

-- DROP VIEW public._vue_nb_eleve_groupe_pedagogique;

CREATE OR REPLACE VIEW public._vue_nb_eleve_groupe_pedagogique
 AS
 SELECT atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_sociologique,
    type_niveau.libelle_type_niveau,
    type_groupe_pedagogique.libelle_type_groupe_pedagogique,
    groupe_pedagogique.numero_ordre_groupe,
    effectif_gp.inscrit_g_gp,
    effectif_gp.inscrit_f_gp,
    groupe_pedagogique.redoublants_garcons,
    groupe_pedagogique.redoublants_filles,
    groupe_pedagogique.deux_parents_decedes_garcons,
    groupe_pedagogique.deux_parents_decedes_filles,
    groupe_pedagogique.pere_decede_garcons,
    groupe_pedagogique.pere_decede_filles,
    groupe_pedagogique.mere_decede_garcons,
    groupe_pedagogique.mere_decede_filles,
    groupe_pedagogique.eleves_deplaces_garcons,
    groupe_pedagogique.eleves_deplaces_filles,
    type_serie.libelle_type_serie,
    type_cycle.libelle_type_cycle,
    type_filiere.libelle_type_filiere,
    groupe_pedagogique.nbre_filles_affectees,
    groupe_pedagogique.nbre_garcons_affectes,
    groupe_pedagogique.nbre_filles_parrainees,
    groupe_pedagogique.nbre_garcons_parraines,
    atlas_admin.systeme_enseignement_regroup,
    atlas_admin.statut_etablisement_prescolaire
   FROM effectif_gp,
    atlas_admin,
    type_niveau,
    type_groupe_pedagogique
     RIGHT JOIN groupe_pedagogique ON type_groupe_pedagogique.code_type_groupe_pedagogique = groupe_pedagogique.code_type_groupe_pedagogique
     LEFT JOIN type_cycle ON groupe_pedagogique.code_type_cycle = type_cycle.code_type_cycle
     LEFT JOIN type_filiere ON groupe_pedagogique.code_type_filiere = type_filiere.code_type_filiere
     LEFT JOIN type_serie ON groupe_pedagogique.code_type_serie = type_serie.code_type_serie
  WHERE groupe_pedagogique.numero_ordre_groupe = effectif_gp.numero_ordre_groupe AND groupe_pedagogique.code_type_annee = effectif_gp.code_type_annee AND groupe_pedagogique.code_etablissement = effectif_gp.code_etablissement AND effectif_gp.code_etablissement = atlas_admin.code_etablissement AND effectif_gp.code_type_annee = atlas_admin.code_type_annee AND groupe_pedagogique.code_type_niveau = type_niveau.code_type_niveau;

ALTER TABLE public._vue_nb_eleve_groupe_pedagogique
    OWNER TO postgres;

-- View: public._vue_nb_eleve_type_groupe_pedagogique

-- DROP VIEW public._vue_nb_eleve_type_groupe_pedagogique;

CREATE OR REPLACE VIEW public._vue_nb_eleve_type_groupe_pedagogique
 AS
 SELECT atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_sociologique,
    type_niveau.libelle_type_niveau,
    type_groupe_pedagogique.libelle_type_groupe_pedagogique,
    groupe_pedagogique.numero_ordre_groupe,
    effectif_gp.inscrit_g_gp,
    effectif_gp.inscrit_f_gp,
    groupe_pedagogique.redoublants_garcons,
    groupe_pedagogique.redoublants_filles,
    groupe_pedagogique.deux_parents_decedes_garcons,
    groupe_pedagogique.deux_parents_decedes_filles,
    groupe_pedagogique.pere_decede_garcons,
    groupe_pedagogique.pere_decede_filles,
    groupe_pedagogique.mere_decede_garcons,
    groupe_pedagogique.mere_decede_filles,
    groupe_pedagogique.eleves_deplaces_garcons,
    groupe_pedagogique.eleves_deplaces_filles
   FROM groupe_pedagogique,
    type_groupe_pedagogique,
    type_niveau,
    atlas_admin,
    effectif_gp
  WHERE groupe_pedagogique.code_type_groupe_pedagogique = type_groupe_pedagogique.code_type_groupe_pedagogique AND groupe_pedagogique.code_type_niveau = type_niveau.code_type_niveau AND groupe_pedagogique.code_etablissement = atlas_admin.code_etablissement AND groupe_pedagogique.code_type_annee = atlas_admin.code_type_annee AND groupe_pedagogique.code_type_annee = effectif_gp.code_type_annee AND groupe_pedagogique.code_etablissement = effectif_gp.code_etablissement AND groupe_pedagogique.numero_ordre_groupe = effectif_gp.numero_ordre_groupe;

ALTER TABLE public._vue_nb_eleve_type_groupe_pedagogique
    OWNER TO postgres;

-- View: public._vue_nb_type_groupe_pedagogique

-- DROP VIEW public._vue_nb_type_groupe_pedagogique;

CREATE OR REPLACE VIEW public._vue_nb_type_groupe_pedagogique
 AS
 SELECT type_niveau.libelle_type_niveau,
    type_groupe_pedagogique.libelle_type_groupe_pedagogique,
    atlas_admin.code_province,
    atlas_admin.statut_etablisement_regroup,
    type_niveau.code_type_niveau,
    type_groupe_pedagogique.code_type_groupe_pedagogique,
    atlas_admin.libelle_type_annee,
    atlas_admin.province,
    atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.libelle_type_sociologique,
    atlas_admin.systeme_enseignement,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    groupe_pedagogique.code_etablissement,
    groupe_pedagogique.numero_ordre_groupe
   FROM groupe_pedagogique,
    type_groupe_pedagogique,
    type_niveau,
    atlas_admin
  WHERE groupe_pedagogique.code_type_groupe_pedagogique = type_groupe_pedagogique.code_type_groupe_pedagogique AND groupe_pedagogique.code_type_niveau = type_niveau.code_type_niveau AND groupe_pedagogique.code_etablissement = atlas_admin.code_etablissement AND groupe_pedagogique.code_type_annee = atlas_admin.code_type_annee;

ALTER TABLE public._vue_nb_type_groupe_pedagogique
    OWNER TO postgres;

-- View: public._vue_principaux_chiffres_et_commodite

-- DROP VIEW public._vue_principaux_chiffres_et_commodite;

CREATE OR REPLACE VIEW public._vue_principaux_chiffres_et_commodite
 AS
 SELECT atlas_admin.region,
    atlas_admin.province,
    atlas_admin.commune,
    atlas_admin.nom_etablissement,
    atlas_admin.systeme_enseignement,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_reconnaissance,
    atlas_admin.libelle_type_promoteur,
    atlas_admin.libelle_type_sociologique,
    atlas_admin.libelle_type_recrutement,
    atlas_admin.libelle_type_cpaf,
    atlas_admin.libelle_type_approche,
    atlas_admin.libelle_type_lieu_alphabetisation,
    atlas_admin.libelle_type_formule,
    atlas_admin.libelle_type_operateur,
    atlas_admin.libelle_type_financement,
    atlas_admin.libelle_type_langue,
    atlas_admin.libelle_type_formalite,
    atlas_admin.code_etablissement,
    atlas_admin.code_type_annee,
    count(atlas_admin.code_etablissement) AS nb_etablissement,
    nb_salle_classe.salles_classes,
    nb_salle_classe_sous_paillote.salle_sous_paillote,
    nb_enseignant_charge_cours.enseignant,
    nb_eleve.garcons,
    nb_eleve.filles,
    donnees_etablissement.jardin AS ecole_jardins_scolaires,
    donnees_etablissement.cantine_presence AS ecole_cantine,
    donnees_etablissement.presence_terrain_sport AS ecole_terrain_sport,
    donnees_etablissement.presence_cloture AS ecole_cloture,
        CASE
            WHEN donnees_etablissement.eau_courante_ecole = 1 OR donnees_etablissement.eau_forage_ecole = 1 OR donnees_etablissement.eau_puits_moderne = 1 THEN 1
            ELSE 0
        END AS ecole_eau_potable,
        CASE
            WHEN donnees_etablissement.electricite_sonabel = 1 OR donnees_etablissement.electricite_groupe_electrogene = 1 OR donnees_etablissement.electricite_panneau_solaire = 1 OR donnees_etablissement.electricite_autre_source = 1 THEN 1
            ELSE 0
        END AS ecole_electricite,
        CASE
            WHEN donnees_etablissement.nb_latrine_cabines_fonctionnelles > 0 THEN 1
            ELSE 0
        END AS ecole_latrines_fonctionnelles,
        CASE nb_salle_classe.salles_classes IS NOT NULL
            WHEN nb_salle_classe.salles_classes = 0 THEN 'ecole 0 salle classe'::text
            WHEN nb_salle_classe.salles_classes = 1 THEN 'ecole 1 salle classe'::text
            WHEN nb_salle_classe.salles_classes = 2 THEN 'ecole 2 salles classes'::text
            WHEN nb_salle_classe.salles_classes = 3 THEN 'ecole 3 salles classes'::text
            WHEN nb_salle_classe.salles_classes = 4 THEN 'ecole 4 salles classes'::text
            WHEN nb_salle_classe.salles_classes = 5 THEN 'ecole 5 salles classes'::text
            WHEN nb_salle_classe.salles_classes = 6 THEN 'ecole 6 salles classes'::text
            WHEN nb_salle_classe.salles_classes = 7 THEN 'ecole 7 salles classes'::text
            WHEN nb_salle_classe.salles_classes = 8 THEN 'ecole 8 salles classes'::text
            WHEN nb_salle_classe.salles_classes = 9 THEN 'ecole 9 salles classes'::text
            WHEN nb_salle_classe.salles_classes = 10 THEN 'ecole 10 salles classes'::text
            WHEN nb_salle_classe.salles_classes > 10 THEN 'ecole > à 10 salles classes'::text
            ELSE 'indeterminé'::text
        END AS ecole_salle_classe,
        CASE nb_salle_classe.salles_classes IS NOT NULL
            WHEN nb_salle_classe.salles_classes = 0 THEN 1
            WHEN nb_salle_classe.salles_classes = 1 THEN 2
            WHEN nb_salle_classe.salles_classes = 2 THEN 3
            WHEN nb_salle_classe.salles_classes = 3 THEN 4
            WHEN nb_salle_classe.salles_classes = 4 THEN 5
            WHEN nb_salle_classe.salles_classes = 5 THEN 6
            WHEN nb_salle_classe.salles_classes = 6 THEN 7
            WHEN nb_salle_classe.salles_classes = 7 THEN 8
            WHEN nb_salle_classe.salles_classes = 8 THEN 9
            WHEN nb_salle_classe.salles_classes = 9 THEN 10
            WHEN nb_salle_classe.salles_classes = 10 THEN 11
            WHEN nb_salle_classe.salles_classes > 10 THEN 12
            ELSE 255
        END AS ordre_ecole_salle_classe,
    place_assise.place_assises,
    COALESCE(nb_eleve.garcons, 0::bigint) + COALESCE(nb_eleve.filles, 0::bigint) AS total_effectif,
        CASE
            WHEN (COALESCE(nb_eleve.garcons, 0::bigint) + COALESCE(nb_eleve.filles, 0::bigint)) > COALESCE(place_assise.place_assises, 0::bigint) THEN 0
            ELSE 1
        END AS ecole_suffisant_table_banc,
    COALESCE(nb_eleve.garcons, 0::bigint) + COALESCE(nb_eleve.filles, 0::bigint) - COALESCE(place_assise.place_assises, 0::bigint) AS deficite_place_assises,
    atlas_admin.systeme_enseignement_regroup,
    atlas_admin.statut_etablisement_prescolaire
   FROM atlas_admin
     LEFT JOIN nb_enseignant_charge_cours ON atlas_admin.code_etablissement = nb_enseignant_charge_cours.code_etablissement AND atlas_admin.code_type_annee = nb_enseignant_charge_cours.code_type_annee
     LEFT JOIN nb_eleve ON atlas_admin.code_etablissement = nb_eleve.code_etablissement AND atlas_admin.code_type_annee = nb_eleve.code_type_annee
     LEFT JOIN nb_salle_classe_sous_paillote ON atlas_admin.code_etablissement = nb_salle_classe_sous_paillote.code_etablissement AND atlas_admin.code_type_annee = nb_salle_classe_sous_paillote.code_type_annee
     LEFT JOIN nb_salle_classe ON atlas_admin.code_etablissement = nb_salle_classe.code_etablissement AND atlas_admin.code_type_annee = nb_salle_classe.code_type_annee
     LEFT JOIN donnees_etablissement ON atlas_admin.code_etablissement = donnees_etablissement.code_etablissement AND atlas_admin.code_type_annee = donnees_etablissement.code_type_annee
     LEFT JOIN place_assise ON atlas_admin.code_etablissement = place_assise.code_etablissement AND atlas_admin.code_type_annee = place_assise.code_type_annee
  GROUP BY atlas_admin.code_etablissement, atlas_admin.code_type_annee, nb_salle_classe.salles_classes, nb_salle_classe_sous_paillote.salle_sous_paillote, nb_enseignant_charge_cours.enseignant, nb_eleve.garcons, nb_eleve.filles, atlas_admin.region, atlas_admin.province, atlas_admin.commune, atlas_admin.nom_etablissement, atlas_admin.systeme_enseignement, atlas_admin.libelle_type_annee, atlas_admin.libelle_type_etablissement, atlas_admin.libelle_type_statut_etablissement, atlas_admin.statut_etablisement_regroup, atlas_admin.libelle_type_reconnaissance, atlas_admin.libelle_type_promoteur, atlas_admin.libelle_type_sociologique, atlas_admin.libelle_type_recrutement, atlas_admin.libelle_type_cpaf, atlas_admin.libelle_type_approche, atlas_admin.libelle_type_lieu_alphabetisation, atlas_admin.libelle_type_formule, atlas_admin.libelle_type_operateur, atlas_admin.libelle_type_financement, atlas_admin.libelle_type_langue, atlas_admin.libelle_type_formalite, donnees_etablissement.jardin, donnees_etablissement.cantine_presence, donnees_etablissement.presence_terrain_sport, place_assise.place_assises, donnees_etablissement.presence_cloture, (
        CASE
            WHEN donnees_etablissement.eau_courante_ecole = 1 OR donnees_etablissement.eau_forage_ecole = 1 OR donnees_etablissement.eau_puits_moderne = 1 THEN 1
            ELSE 0
        END), (
        CASE
            WHEN donnees_etablissement.electricite_sonabel = 1 OR donnees_etablissement.electricite_groupe_electrogene = 1 OR donnees_etablissement.electricite_panneau_solaire = 1 OR donnees_etablissement.electricite_autre_source = 1 THEN 1
            ELSE 0
        END), (
        CASE
            WHEN donnees_etablissement.nb_latrine_cabines_fonctionnelles > 0 THEN 1
            ELSE 0
        END), atlas_admin.systeme_enseignement_regroup, atlas_admin.statut_etablisement_prescolaire;

ALTER TABLE public._vue_principaux_chiffres_et_commodite
    OWNER TO postgres;

-- View: public._vue_taux_brut_admission_post_primaire

-- DROP VIEW public._vue_taux_brut_admission_post_primaire;

CREATE OR REPLACE VIEW public._vue_taux_brut_admission_post_primaire
 AS
 SELECT prov_nouveau_inscrits.code_province,
    prov_nouveau_inscrits.province,
    prov_nouveau_inscrits.code_type_annee,
    prov_nouveau_inscrits.libelle_type_annee,
    prov_nouveau_inscrits.prov_nvx_insc_g,
    prov_nouveau_inscrits.prov_nvx_insc_f,
    pop_12_ans.pop_12_ans_g,
    pop_12_ans.pop_12_ans_f
   FROM pop_12_ans,
    prov_nouveau_inscrits
  WHERE pop_12_ans.code_regroupement = prov_nouveau_inscrits.code_province AND pop_12_ans.code_type_annee = prov_nouveau_inscrits.code_type_annee AND prov_nouveau_inscrits.code_type_niveau = 10;

ALTER TABLE public._vue_taux_brut_admission_post_primaire
    OWNER TO postgres;

-- View: public._vue_taux_brut_admission_primaire

-- DROP VIEW public._vue_taux_brut_admission_primaire;

CREATE OR REPLACE VIEW public._vue_taux_brut_admission_primaire
 AS
 SELECT prov_nouveau_inscrits.code_province,
    prov_nouveau_inscrits.province,
    prov_nouveau_inscrits.code_type_annee,
    prov_nouveau_inscrits.libelle_type_annee,
    prov_nouveau_inscrits.prov_nvx_insc_g,
    prov_nouveau_inscrits.prov_nvx_insc_f,
    pop_6_ans.pop_6_ans_g,
    pop_6_ans.pop_6_ans_f
   FROM pop_6_ans,
    prov_nouveau_inscrits
  WHERE pop_6_ans.code_regroupement = prov_nouveau_inscrits.code_province AND pop_6_ans.code_type_annee = prov_nouveau_inscrits.code_type_annee AND prov_nouveau_inscrits.code_type_niveau = 4;

ALTER TABLE public._vue_taux_brut_admission_primaire
    OWNER TO postgres;

-- View: public._vue_taux_brut_admission_secondaire

-- DROP VIEW public._vue_taux_brut_admission_secondaire;

CREATE OR REPLACE VIEW public._vue_taux_brut_admission_secondaire
 AS
 SELECT prov_nouveau_inscrits.code_province,
    prov_nouveau_inscrits.province,
    prov_nouveau_inscrits.code_type_annee,
    prov_nouveau_inscrits.libelle_type_annee,
    prov_nouveau_inscrits.prov_nvx_insc_g,
    prov_nouveau_inscrits.prov_nvx_insc_f,
    pop_16_ans.pop_16_ans_g,
    pop_16_ans.pop_16_ans_f
   FROM pop_16_ans,
    prov_nouveau_inscrits
  WHERE pop_16_ans.code_regroupement = prov_nouveau_inscrits.code_province AND pop_16_ans.code_type_annee = prov_nouveau_inscrits.code_type_annee AND prov_nouveau_inscrits.code_type_niveau = 14;

ALTER TABLE public._vue_taux_brut_admission_secondaire
    OWNER TO postgres;

-- View: public._vue_taux_brut_scolarisation_post_primaire

-- DROP VIEW public._vue_taux_brut_scolarisation_post_primaire;

CREATE OR REPLACE VIEW public._vue_taux_brut_scolarisation_post_primaire
 AS
 SELECT prov_nb_eleve.code_province,
    prov_nb_eleve.province,
    prov_nb_eleve.code_type_annee,
    prov_nb_eleve.libelle_type_annee,
    prov_nb_eleve.code_systeme_enseignement,
    pop_12_15_ans.pop_12_15_ans_g AS pop_12_15_ans_g_post_primaire,
    pop_12_15_ans.pop_12_15_ans_f AS pop_12_15_ans_f_post_primaire,
    prov_nb_eleve.prov_insc_f AS prov_insc_f_post_primaire,
    prov_nb_eleve.prov_insc_g AS prov_insc_g_post_primaire
   FROM pop_12_15_ans
     JOIN prov_nb_eleve ON pop_12_15_ans.code_type_annee = prov_nb_eleve.code_type_annee AND pop_12_15_ans.code_regroupement = prov_nb_eleve.code_province
  WHERE prov_nb_eleve.code_systeme_enseignement = ANY (ARRAY[3, 4, 5, 6]);

ALTER TABLE public._vue_taux_brut_scolarisation_post_primaire
    OWNER TO postgres;
COMMENT ON VIEW public._vue_taux_brut_scolarisation_post_primaire
    IS 'taux brut de scolarisation post primaire';

-- View: public._vue_taux_brut_scolarisation_post_primaire_EFTPCJ

-- DROP VIEW public."_vue_taux_brut_scolarisation_post_primaire_EFTPCJ";

CREATE OR REPLACE VIEW public."_vue_taux_brut_scolarisation_post_primaire_EFTPCJ"
 AS
 SELECT prov_nb_eleve.code_province,
    prov_nb_eleve.province,
    prov_nb_eleve.code_type_annee,
    prov_nb_eleve.libelle_type_annee,
    pop_12_15_ans.pop_12_15_ans_g AS pop_12_15_ans_g_post_primaire,
    pop_12_15_ans.pop_12_15_ans_f AS pop_12_15_ans_f_post_primaire,
    prov_nb_eleve.prov_insc_f AS prov_insc_f_post_primaire,
    prov_nb_eleve.prov_insc_g AS prov_insc_g_post_primaire
   FROM pop_12_15_ans,
    prov_nb_eleve
  WHERE pop_12_15_ans.code_type_annee = prov_nb_eleve.code_type_annee AND pop_12_15_ans.code_regroupement = prov_nb_eleve.code_province AND prov_nb_eleve.code_systeme_enseignement = 4;

ALTER TABLE public."_vue_taux_brut_scolarisation_post_primaire_EFTPCJ"
    OWNER TO postgres;
COMMENT ON VIEW public."_vue_taux_brut_scolarisation_post_primaire_EFTPCJ"
    IS 'taux brut de scolarisation post primaire enseigenement technique cours du jour';

-- View: public._vue_taux_brut_scolarisation_post_primaire_EFTPCS

-- DROP VIEW public."_vue_taux_brut_scolarisation_post_primaire_EFTPCS";

CREATE OR REPLACE VIEW public."_vue_taux_brut_scolarisation_post_primaire_EFTPCS"
 AS
 SELECT prov_nb_eleve.code_province,
    prov_nb_eleve.province,
    prov_nb_eleve.code_type_annee,
    prov_nb_eleve.libelle_type_annee,
    pop_12_15_ans.pop_12_15_ans_g AS pop_12_15_ans_g_post_primaire,
    pop_12_15_ans.pop_12_15_ans_f AS pop_12_15_ans_f_post_primaire,
    prov_nb_eleve.prov_insc_f AS prov_insc_f_post_primaire,
    prov_nb_eleve.prov_insc_g AS prov_insc_g_post_primaire
   FROM pop_12_15_ans,
    prov_nb_eleve
  WHERE pop_12_15_ans.code_type_annee = prov_nb_eleve.code_type_annee AND pop_12_15_ans.code_regroupement = prov_nb_eleve.code_province AND prov_nb_eleve.code_systeme_enseignement = 6;

ALTER TABLE public."_vue_taux_brut_scolarisation_post_primaire_EFTPCS"
    OWNER TO postgres;
COMMENT ON VIEW public."_vue_taux_brut_scolarisation_post_primaire_EFTPCS"
    IS 'taux brut de scolarisation post primaire enseigenement technique cours du soir';

-- View: public._vue_taux_brut_scolarisation_post_primaire_EGCJ

-- DROP VIEW public."_vue_taux_brut_scolarisation_post_primaire_EGCJ";

CREATE OR REPLACE VIEW public."_vue_taux_brut_scolarisation_post_primaire_EGCJ"
 AS
 SELECT prov_nb_eleve.code_province,
    prov_nb_eleve.province,
    prov_nb_eleve.code_type_annee,
    prov_nb_eleve.libelle_type_annee,
    pop_12_15_ans.pop_12_15_ans_g AS pop_12_15_ans_g_post_primaire,
    pop_12_15_ans.pop_12_15_ans_f AS pop_12_15_ans_f_post_primaire,
    prov_nb_eleve.prov_insc_f AS prov_insc_f_post_primaire,
    prov_nb_eleve.prov_insc_g AS prov_insc_g_post_primaire
   FROM pop_12_15_ans,
    prov_nb_eleve
  WHERE pop_12_15_ans.code_type_annee = prov_nb_eleve.code_type_annee AND pop_12_15_ans.code_regroupement = prov_nb_eleve.code_province AND prov_nb_eleve.code_systeme_enseignement = 3;

ALTER TABLE public."_vue_taux_brut_scolarisation_post_primaire_EGCJ"
    OWNER TO postgres;
COMMENT ON VIEW public."_vue_taux_brut_scolarisation_post_primaire_EGCJ"
    IS 'taux brut de scolarisation post primaire enseigenement général cours du jour';

-- View: public._vue_taux_brut_scolarisation_post_primaire_EGCS

-- DROP VIEW public."_vue_taux_brut_scolarisation_post_primaire_EGCS";

CREATE OR REPLACE VIEW public."_vue_taux_brut_scolarisation_post_primaire_EGCS"
 AS
 SELECT prov_nb_eleve.code_province,
    prov_nb_eleve.province,
    prov_nb_eleve.code_type_annee,
    prov_nb_eleve.libelle_type_annee,
    pop_12_15_ans.pop_12_15_ans_g AS pop_12_15_ans_g_post_primaire,
    pop_12_15_ans.pop_12_15_ans_f AS pop_12_15_ans_f_post_primaire,
    prov_nb_eleve.prov_insc_f AS prov_insc_f_post_primaire,
    prov_nb_eleve.prov_insc_g AS prov_insc_g_post_primaire
   FROM pop_12_15_ans,
    prov_nb_eleve
  WHERE pop_12_15_ans.code_type_annee = prov_nb_eleve.code_type_annee AND pop_12_15_ans.code_regroupement = prov_nb_eleve.code_province AND prov_nb_eleve.code_systeme_enseignement = 5;

ALTER TABLE public."_vue_taux_brut_scolarisation_post_primaire_EGCS"
    OWNER TO postgres;
COMMENT ON VIEW public."_vue_taux_brut_scolarisation_post_primaire_EGCS"
    IS '''taux brut de scolarisation post primaire enseigenement général cours du soir';

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

-- View: public._vue_taux_net_scolairisation_post_primaire

-- DROP VIEW public._vue_taux_net_scolairisation_post_primaire;

CREATE OR REPLACE VIEW public._vue_taux_net_scolairisation_post_primaire
 AS
 SELECT prov_nb_eleve_12_15_ans.code_region,
    prov_nb_eleve_12_15_ans.region,
    prov_nb_eleve_12_15_ans.code_province,
    prov_nb_eleve_12_15_ans.province,
    prov_nb_eleve_12_15_ans.code_type_annee,
    prov_nb_eleve_12_15_ans.libelle_type_annee,
    prov_nb_eleve_12_15_ans.insc_g_12_15 AS inscr_prov_g_12_15,
    prov_nb_eleve_12_15_ans.insc_f_12_15 AS inscr_prov_f_12_15,
    pop_12_15_ans.pop_12_15_ans_g AS pop_prov_g_12_15,
    pop_12_15_ans.pop_12_15_ans_f AS pop_nat_f_12_15
   FROM pop_12_15_ans,
    prov_nb_eleve_12_15_ans
  WHERE pop_12_15_ans.code_type_annee = prov_nb_eleve_12_15_ans.code_type_annee;

ALTER TABLE public._vue_taux_net_scolairisation_post_primaire
    OWNER TO postgres;

-- View: public._vue_taux_net_scolairisation_primaire

-- DROP VIEW public._vue_taux_net_scolairisation_primaire;

CREATE OR REPLACE VIEW public._vue_taux_net_scolairisation_primaire
 AS
 SELECT prov_nb_eleve_6_11_ans.code_type_annee,
    prov_nb_eleve_6_11_ans.libelle_type_annee,
    prov_nb_eleve_6_11_ans.code_province,
    prov_nb_eleve_6_11_ans.province,
    prov_nb_eleve_6_11_ans.prov_insc_g_6_11,
    prov_nb_eleve_6_11_ans.prov_insc_f_6_11,
    pop_6_11_ans.pop_6_11_ans_g,
    pop_6_11_ans.pop_6_11_ans_f
   FROM pop_6_11_ans,
    prov_nb_eleve_6_11_ans
  WHERE pop_6_11_ans.code_type_annee = prov_nb_eleve_6_11_ans.code_type_annee AND pop_6_11_ans.code_regroupement = prov_nb_eleve_6_11_ans.code_province;

ALTER TABLE public._vue_taux_net_scolairisation_primaire
    OWNER TO postgres;

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

-- View: public._vue_taux_scolarisation_primaire

-- DROP VIEW public._vue_taux_scolarisation_primaire;

CREATE OR REPLACE VIEW public._vue_taux_scolarisation_primaire
 AS
 SELECT prov_nb_eleve.code_province,
    prov_nb_eleve.province,
    prov_nb_eleve.code_type_annee,
    prov_nb_eleve.libelle_type_annee,
    pop_6_11_ans.pop_6_11_ans_g AS pop_6_11_ans_g_prim,
    pop_6_11_ans.pop_6_11_ans_f AS pop_6_11_ans_f_prim,
    prov_nb_eleve.prov_insc_f AS prov_insc_f_prim,
    prov_nb_eleve.prov_insc_g AS prov_insc_g_prim
   FROM pop_6_11_ans,
    prov_nb_eleve
  WHERE pop_6_11_ans.code_type_annee = prov_nb_eleve.code_type_annee AND pop_6_11_ans.code_regroupement = prov_nb_eleve.code_province AND prov_nb_eleve.code_systeme_enseignement = 2;

ALTER TABLE public._vue_taux_scolarisation_primaire
    OWNER TO postgres;





--Les Tables Temporaires--

-- Table: public._table_effectifs_eleves

-- DROP Table public._table_effectifs_eleves;

DROP TABLE IF EXISTS _table_effectifs_eleves;
CREATE TABLE IF NOT EXISTS _table_effectifs_eleves
 AS
 SELECT atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_reconnaissance,
    atlas_admin.libelle_type_promoteur,
    atlas_admin.libelle_type_sociologique,
    atlas_admin.libelle_type_recrutement,
    atlas_admin.libelle_type_cpaf,
    atlas_admin.libelle_type_approche,
    atlas_admin.libelle_type_lieu_alphabetisation,
    atlas_admin.libelle_type_formule,
    atlas_admin.libelle_type_operateur,
    atlas_admin.libelle_type_financement,
    atlas_admin.libelle_type_langue,
    atlas_admin.libelle_type_formalite,
    effectif_gp_par_age.code_type_age,
    effectif_gp_par_age.inscrits_garcons,
    effectif_gp_par_age.inscrits_filles,
    effectif_gp_par_age.evalues_reg_insc_garcons,
    effectif_gp_par_age.evalues_reg_insc_filles,
    effectif_gp_par_age.evalues_libres_garcons,
    effectif_gp_par_age.evalues_libres_filles,
    effectif_gp_par_age.admis_reg_insc_garcons,
    effectif_gp_par_age.admis_reg_insc_filles,
    effectif_gp_par_age.admis_total_garcons,
    effectif_gp_par_age.admis_total_filles,
    effectif_gp_par_age.abandons_garcons,
    effectif_gp_par_age.abandons_filles,
    effectif_gp_par_age.numero_local,
    effectif_gp_par_age.g_premiere_insc,
    effectif_gp_par_age.f_premiere_insc,
    effectif_gp_par_age.total_premiere_insc,
    type_niveau.libelle_type_niveau,
    type_niveau.ordre_type_niveau,
    type_age.libelle_type_age,
    type_age.ordre_type_age,
    COALESCE(effectif_gp_par_age.inscrits_garcons, 0) + COALESCE(effectif_gp_par_age.inscrits_filles, 0) AS total_effectif,
    atlas_admin.systeme_enseignement_regroup,
    atlas_admin.statut_etablisement_prescolaire,
    type_serie.libelle_type_serie,
    type_cycle.libelle_type_cycle,
    type_filiere.libelle_type_filiere
   FROM atlas_admin,
    effectif_gp_par_age,
    type_age,
    type_niveau,
    groupe_pedagogique
     LEFT JOIN type_serie ON groupe_pedagogique.code_type_serie = type_serie.code_type_serie
     LEFT JOIN type_cycle ON groupe_pedagogique.code_type_cycle = type_cycle.code_type_cycle
     LEFT JOIN type_filiere ON groupe_pedagogique.code_type_filiere = type_filiere.code_type_filiere
  WHERE groupe_pedagogique.code_etablissement = atlas_admin.code_etablissement AND groupe_pedagogique.code_type_annee = atlas_admin.code_type_annee AND groupe_pedagogique.numero_ordre_groupe = effectif_gp_par_age.numero_ordre_groupe AND groupe_pedagogique.code_etablissement = effectif_gp_par_age.code_etablissement AND groupe_pedagogique.code_type_annee = effectif_gp_par_age.code_type_annee AND groupe_pedagogique.code_type_niveau = type_niveau.code_type_niveau AND effectif_gp_par_age.code_type_age = type_age.code_type_age;

ALTER TABLE public._vue_effectifs_eleves
    OWNER TO postgres;


-- Table: public._table_effectif_nvx_insc_cp1_presco

-- DROP TABLE public._table_effectif_nvx_insc_cp1_presco;

DROP TABLE IF EXISTS _table_effectif_nvx_insc_cp1_presco;
CREATE TABLE IF NOT EXISTS _table_effectif_nvx_insc_cp1_presco
 AS
 SELECT atlas_admin.code_type_annee,
    etab_nouveaux_inscrits_cp1.code_etablissement,
    atlas_admin.region,
    atlas_admin.province,
    atlas_admin.commune,
    atlas_admin.nom_etablissement,
    atlas_admin.systeme_enseignement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.systeme_enseignement_regroup,
    atlas_admin.statut_etablisement_prescolaire,
    atlas_admin.libelle_type_sociologique,
    etab_nouveaux_inscrits_cp1.nvx_insc_g_etab,
    etab_nouveaux_inscrits_cp1.nvx_insc_f_etab,
    etab_nouveaux_inscrits_prescolaire.presc_insc_g,
    etab_nouveaux_inscrits_prescolaire.presc_inc_f
   FROM atlas_admin
     LEFT JOIN etab_nouveaux_inscrits_prescolaire ON atlas_admin.code_etablissement = etab_nouveaux_inscrits_prescolaire.code_etablissement AND atlas_admin.code_type_annee = etab_nouveaux_inscrits_prescolaire.code_type_annee
     LEFT JOIN etab_nouveaux_inscrits_cp1 ON atlas_admin.code_etablissement = etab_nouveaux_inscrits_cp1.code_etablissement AND atlas_admin.code_type_annee = etab_nouveaux_inscrits_cp1.code_type_annee
     LEFT JOIN etab_nouveaux_inscrits_prescolaire etab_nouveaux_inscrits_prescolaire_1 ON atlas_admin.code_type_annee = etab_nouveaux_inscrits_prescolaire_1.code_type_annee AND atlas_admin.code_etablissement = etab_nouveaux_inscrits_prescolaire_1.code_etablissement
  WHERE atlas_admin.code_systeme_enseignement = 2;

ALTER TABLE _table_effectif_nvx_insc_cp1_presco
    OWNER TO postgres;


-- Table: _table_effectif_nvx_insc_par_age

-- DROP TABLE _table_effectif_nvx_insc_par_age;

DROP TABLE IF EXISTS _table_effectif_nvx_insc_par_age;
CREATE TABLE IF NOT EXISTS _table_effectif_nvx_insc_par_age
 AS
 SELECT atlas_admin.region,
    atlas_admin.province,
    atlas_admin.commune,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.systeme_enseignement,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_sociologique,
    atlas_admin.systeme_enseignement_regroup,
    atlas_admin.statut_etablisement_prescolaire,
    type_niveau.libelle_type_niveau,
    type_age.libelle_type_age,
    nouveaux_inscrits.nouveaux_inscrits_garcons,
    nouveaux_inscrits.nouveaux_inscrits_filles
   FROM type_age,
    nouveaux_inscrits,
    atlas_admin,
    type_niveau
  WHERE type_age.code_type_age = nouveaux_inscrits.code_type_age AND nouveaux_inscrits.code_etablissement = atlas_admin.code_etablissement AND nouveaux_inscrits.code_type_annee = atlas_admin.code_type_annee AND nouveaux_inscrits.code_type_niveau = type_niveau.code_type_niveau;

ALTER TABLE _table_effectif_nvx_insc_par_age
    OWNER TO postgres;

-- View: _table_effectif_par_profession_parent

-- DROP TABLE _table_effectif_par_profession_parent;

DROP TABLE IF EXISTS _table_effectif_par_profession_parent;
CREATE TABLE IF NOT EXISTS _table_effectif_par_profession_parent
 AS
 SELECT atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    effectif_gp_par_profession.code_type_profession,
    type_profession.libelle_type_profession,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_sociologique,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    sum(effectif_gp_par_profession.garcon_profession) AS profession_g,
    sum(effectif_gp_par_profession.filles_profession) AS profession_f,
    atlas_admin.systeme_enseignement_regroup,
    atlas_admin.statut_etablisement_prescolaire,
    atlas_admin.libelle_type_formalite,
    type_serie.libelle_type_serie,
    type_cycle.libelle_type_cycle,
    type_filiere.libelle_type_filiere
   FROM effectif_gp_par_profession,
    type_profession,
    atlas_admin,
    groupe_pedagogique
     LEFT JOIN type_serie ON groupe_pedagogique.code_type_serie = type_serie.code_type_serie
     LEFT JOIN type_cycle ON groupe_pedagogique.code_type_cycle = type_cycle.code_type_cycle
     LEFT JOIN type_filiere ON groupe_pedagogique.code_type_filiere = type_filiere.code_type_filiere
  WHERE effectif_gp_par_profession.code_type_profession = type_profession.code_type_profession AND groupe_pedagogique.code_etablissement = atlas_admin.code_etablissement AND groupe_pedagogique.code_type_annee = atlas_admin.code_type_annee AND groupe_pedagogique.numero_ordre_groupe = effectif_gp_par_profession.numero_ordre_groupe AND groupe_pedagogique.code_etablissement = effectif_gp_par_profession.code_etablissement AND groupe_pedagogique.code_type_annee = effectif_gp_par_profession.code_type_annee
  GROUP BY atlas_admin.code_region, atlas_admin.region, atlas_admin.code_province, atlas_admin.province, atlas_admin.code_commune, atlas_admin.commune, atlas_admin.code_type_annee, atlas_admin.libelle_type_annee, type_profession.libelle_type_profession, effectif_gp_par_profession.code_type_profession, atlas_admin.code_etablissement, atlas_admin.nom_etablissement, atlas_admin.statut_etablisement_regroup, atlas_admin.libelle_type_sociologique, atlas_admin.libelle_type_statut_etablissement, atlas_admin.libelle_type_etablissement, atlas_admin.code_systeme_enseignement, atlas_admin.systeme_enseignement, atlas_admin.systeme_enseignement_regroup, atlas_admin.statut_etablisement_prescolaire, atlas_admin.libelle_type_formalite, type_serie.libelle_type_serie, type_cycle.libelle_type_cycle, type_filiere.libelle_type_filiere;

ALTER TABLE _table_effectif_par_profession_parent
    OWNER TO postgres;


-- Table: _table_nb_eleve_groupe_pedagogique

-- DROP TABLE _table_nb_eleve_groupe_pedagogique;

DROP TABLE IF EXISTS _table_nb_eleve_groupe_pedagogique;
CREATE TABLE IF NOT EXISTS public._table_nb_eleve_groupe_pedagogique
 AS
 SELECT atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_commune,
    atlas_admin.commune,
    atlas_admin.code_etablissement,
    atlas_admin.nom_etablissement,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    atlas_admin.libelle_type_etablissement,
    atlas_admin.libelle_type_statut_etablissement,
    atlas_admin.statut_etablisement_regroup,
    atlas_admin.libelle_type_sociologique,
    type_niveau.libelle_type_niveau,
    type_groupe_pedagogique.libelle_type_groupe_pedagogique,
    groupe_pedagogique.numero_ordre_groupe,
    effectif_gp.inscrit_g_gp,
    effectif_gp.inscrit_f_gp,
    groupe_pedagogique.redoublants_garcons,
    groupe_pedagogique.redoublants_filles,
    groupe_pedagogique.deux_parents_decedes_garcons,
    groupe_pedagogique.deux_parents_decedes_filles,
    groupe_pedagogique.pere_decede_garcons,
    groupe_pedagogique.pere_decede_filles,
    groupe_pedagogique.mere_decede_garcons,
    groupe_pedagogique.mere_decede_filles,
    groupe_pedagogique.eleves_deplaces_garcons,
    groupe_pedagogique.eleves_deplaces_filles,
    type_serie.libelle_type_serie,
    type_cycle.libelle_type_cycle,
    type_filiere.libelle_type_filiere,
    groupe_pedagogique.nbre_filles_affectees,
    groupe_pedagogique.nbre_garcons_affectes,
    groupe_pedagogique.nbre_filles_parrainees,
    groupe_pedagogique.nbre_garcons_parraines,
    atlas_admin.systeme_enseignement_regroup,
    atlas_admin.statut_etablisement_prescolaire
   FROM effectif_gp,
    atlas_admin,
    type_niveau,
    type_groupe_pedagogique
     RIGHT JOIN groupe_pedagogique ON type_groupe_pedagogique.code_type_groupe_pedagogique = groupe_pedagogique.code_type_groupe_pedagogique
     LEFT JOIN type_cycle ON groupe_pedagogique.code_type_cycle = type_cycle.code_type_cycle
     LEFT JOIN type_filiere ON groupe_pedagogique.code_type_filiere = type_filiere.code_type_filiere
     LEFT JOIN type_serie ON groupe_pedagogique.code_type_serie = type_serie.code_type_serie
  WHERE groupe_pedagogique.numero_ordre_groupe = effectif_gp.numero_ordre_groupe AND groupe_pedagogique.code_type_annee = effectif_gp.code_type_annee AND groupe_pedagogique.code_etablissement = effectif_gp.code_etablissement AND effectif_gp.code_etablissement = atlas_admin.code_etablissement AND effectif_gp.code_type_annee = atlas_admin.code_type_annee AND groupe_pedagogique.code_type_niveau = type_niveau.code_type_niveau;

ALTER TABLE _table_nb_eleve_groupe_pedagogique
    OWNER TO postgres;
-----------------------------Fin table temporaire ---------------

----###############" 04 mai 2023 Ziniaré"####################"
CREATE OR REPLACE VIEW public._vue_taux_prescolarisation
 AS
 SELECT prov_nb_eleve.code_province,
    prov_nb_eleve.province,
    prov_nb_eleve.code_type_annee,
    prov_nb_eleve.libelle_type_annee,
    pop_3_5_ans.pop_3_5_ans_g AS pop_3_5_ans_g_presco,
    pop_3_5_ans.pop_3_5_ans_f AS pop_3_5_ans_f_presco,
    prov_nb_eleve.prov_insc_f AS prov_insc_f_presco,
    prov_nb_eleve.prov_insc_g AS prov_insc_g_presco
   FROM pop_3_5_ans,
    prov_nb_eleve
  WHERE 
  pop_3_5_ans.code_type_annee = prov_nb_eleve.code_type_annee 
  AND 
  pop_3_5_ans.code_regroupement = prov_nb_eleve.code_province 
  AND prov_nb_eleve.code_systeme_enseignement = 1;

ALTER TABLE public._vue_taux_prescolarisation
    OWNER TO postgres;


-----------------05052023--------------------
CREATE OR REPLACE VIEW public.prov_nb_eleve_post_primaire
 AS
 SELECT 
    atlas_admin.code_region,
    atlas_admin.region,
    atlas_admin.code_province,
    atlas_admin.province,
    atlas_admin.code_type_annee,
    atlas_admin.libelle_type_annee,
    atlas_admin.code_systeme_enseignement,
    atlas_admin.systeme_enseignement,
    sum(effectif_gp_par_age.inscrits_filles) AS prov_insc_f,
    sum(effectif_gp_par_age.inscrits_garcons) AS prov_insc_g
   FROM effectif_gp_par_age,
    atlas_admin
  WHERE effectif_gp_par_age.code_etablissement = atlas_admin.code_etablissement AND effectif_gp_par_age.code_type_annee = atlas_admin.code_type_annee
  GROUP BY atlas_admin.code_region, atlas_admin.region, atlas_admin.code_province, atlas_admin.province, atlas_admin.code_type_annee, atlas_admin.libelle_type_annee, atlas_admin.code_systeme_enseignement, atlas_admin.systeme_enseignement;

ALTER TABLE public.prov_nb_eleve
    OWNER TO postgres;