SGBD (Système de Gestion de Base de Données) : logiciel permettant de manipuler les données d’une base de données. Peut être relationnel (sous forme de tables) ou non-relationnel.

Structure d’une base de donnée
---
Base de donnée
    Table1
        Champs1    Champs2    Champs3    ...
        Entrée1.1  Entrée1.2  Entrée1.3
        Entrée2.1  Entrée2.2  Entrée2.3
        ...
    Table2
    ...
---
Connexion à MySQL avec le terminal : mysql -h adresse -u user -pmotDePasse --default-character-set=utf8 --ex: mysql -h localhost -u root -proot --default-character-set=utf8
Déconnexion : quit

Annuler commande terminal : \c
Afficher avertissements : SHOW WARNINGS;    --doit être lancé directement après une erreur, sinon ne fonctionnera pas

Créer une sauvegarde SQL : mysqldump -u user -p --opt nom_de_la_base > nom_de_la_sauvegarde.sql         --va enregistrer une sauvegarde dans le dossier courant, donc utiliser cd avant
Charger une sauvegarde SQL : mysql nom_base < chemin_fichier_de_sauvegarde.sql  --si la BD a été supprimée, il faut la recréer avec CREATE DATABASE nom_base;

Créer un nouvel utilisateur : https://bityl.co/5LHA

Commentaires : --   --doit être suivi d’un espace au moin
String : Utiliser des apostrophes --ex: 'bateau'
Échappement des caractères spéciaux : MySQL utilise \ mais se renseigner pour chaque BD
Définir l’encodage : SET NAMES 'utf8';
Afficher avertissement MySQL : SHOW WARNINGS;

Types de données MySQL: https://bityl.co/5LJQ --TODO à retranscrire ici
Types courants : 
INT(size) : nombre entier ;
DOUBLE(size, d) : Le nombre total de chiffres est spécifié dans la taille. Le nombre de chiffres après la virgule décimale est spécifié dans le paramètre d
VARCHAR(size) : texte court (entre 1 et 255 caractères) ;
TEXT(size) : long texte (on peut y stocker un roman sans problème) ;
DATE(YYYY-MM-DD) : date (jour, mois, année).
TIME(hh:mm:ss) : Temps en heures minutes et secondes
TIMESTAMP(YYYY-MM-DD hh:mm:ss) : Date et temps

Opérateurs conditionnels : AND, OR, NOT

Créer une BD : CREATE DATABASE nom_base CHARACTER SET 'utf8';
Supprimer une BD : DROP DATABASE IF EXISTS nom_base;
Utiliser une BD : USE nom_base;         --pour spécifier la BD lors de la connexion à MySQL avec le terminal : mysql -u nom_utilisateur -p nom_base
Afficher les BD : SHOW DATABASES;
Afficher BD actuelle : SELECT DATABASE();   --Commande valide pour MySQL mais vérifier pour les autres
Afficher informations sur connexion : STATUS;

Exécuter des commandes SQL à partir d’un fichier : SOURCE monFichier.sql;      --on peut aussi utiliser \. monFichier.sql;

Préciser le moteur de table : ENGINE = INNODB;      --voir ici https://bityl.co/5LPO pour les autres moteurs --les moteurs sont une spécificité de MySQL qui permettent de gérer différemment les tables selon l'utilité que l'on en a

Créer une table ↓    --exemple
.............................
CREATE TABLE IF NOT EXISTS Animal (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,            --sur Oracle, au lieu d’AUTO_INCREMENT, il faut mettre GENERATED {ALWAYS}|{BY DEFAULT [ON NULL]} AS IDENTITY [START WITH valeurInitiale] [INCREMENT BY incrementation]
    espece VARCHAR(40) NOT NULL,
    sexe CHAR(1),
    commentaires TEXT,
    PRIMARY KEY (id)
)
ENGINE=INNODB;
.............................
Supprimer une table : DROP TABLE Nom_table;

Ajouter   colonne à une table : ALTER TABLE nom_table ADD COLUMN nom_colonne description_colonne;
Supprimer colonne d’une table : ALTER TABLE nom_table DROP COLUMN nom_colonne;
Modifier  colonne d’une table : ALTER TABLE nom_table MODIFY nom_colonne nouvelle_description;
Renommer et Modifier colonne d’une table : ALTER TABLE nom_table CHANGE ancien_nom nouveau_nom nouvelle_description;
Liste des utilisation d’ALTER : https://bityl.co/5LQQ

Vider contenu d’une table : TRUNCATE Nom_table;         --on peut aussi utiliser DELETE FROM Nom_table;

Afficher les noms des tables de la BD : SHOW TABLES;
Afficher les informations d’une certaine table : DESCRIBE Nom_table;
Afficher le contenu d’une certaine table : SELECT * FROM Nom_table;

Insérer des données dans une table ↓    --exemple
.............................
    INSERT INTO jeux_video(nom, prix, date_sortie) --pas nécessaire de lister les colonnes après jeux_video, mais cela permet de choisir l'ordre et fait qu'on n'est plus obligé de donner une valeur à chaque colonne
    VALUES('Battlefield 1942', 45, '2010-10-03 16:44:00'),
        ('PAC-MAN',          10, '1988-08-23 12:31:46');
.............................

Insérer des données à partir d’un fichier formaté ↓ 
.............................
    LOAD DATA [LOCAL] INFILE 'nom_fichier'
    INTO TABLE nom_table
    [FIELDS                     --colonnes
        [TERMINATED BY '\t']    --définit le caractère séparant les colonnes
        [ENCLOSED BY '']        --définit le caractère entourant les valeurs dans chaque colonne
        [ESCAPED BY '\\' ]      --définit le caractère d’échappement pour les caractères spéciaux
    ]
    [LINES                      --lignes
        [STARTING BY '']        --définit le caractère de début de ligne (vide par défaut)
        [TERMINATED BY '\n']    --définit le caractère de fin de ligne ('\n'  par défaut, mais les fichiers générés sous Windows ont souvent '\r\n')
    ]
    [IGNORE nombre LINES]       --permet d’ignorer un certain nombre de lignes.  Ex: si la 1ère ligne contient les noms des colonnes, Il suffit d’utiliser IGNORE 1 LINES.
    [(nom_colonne,...)];        --préciser le nom des colonnes présentes dans votre fichier. Attention à ce que les colonnes absentes acceptent NULL ou soient auto-incrémentées.


    Exemple ↓ 

    LOAD DATA LOCAL INFILE 'animal.csv'
    INTO TABLE Animal
    FIELDS TERMINATED BY ';' ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    (espece, sexe, date_naissance, nom, commentaires);
.............................

Sélectionner des données d’une table ↓
.............................
    SELECT [DISTINCT] ...colonnes_voulues        -- * pour tous les champs -- DISTINCT sert à éviter les doublons
    FROM nom_table                            
    [WHERE condition                             --pour filtrer les données reçues
    ORDER BY ...colonnes_par_lequel_ordonner     --ajouter DESC pour ordre décroissant  --tri sur plusieurs colonnes : se fera d’abord sur la première colonne, puis sur la seconde, etc.
    LIMIT nombre_de_lignes [OFFSET decalage];    --Pour renvoyer un nombre limité de résultats.  --syntaxe alternative propre à MySQL: LIMIT [decalage, ]nombre_de_lignes;
    ]


    Exemple ↓ 

    SELECT nom, possesseur, console, prix 
    FROM jeux_video 
    WHERE console='Xbox' OR console='PS2' 
    ORDER BY prix DESC 
    LIMIT 10 OFFSET 0                 --10 premières entrées
.............................

Supprimer des données d’une table: DELETE FROM nom_table WHERE condition;       --opération irréversible. Il est recommandé d’avoir une sauvegarde de la BD au cas ou on regretterais

Édition :  UPDATE nom_table SET col1 = val1, col2 = val2 ... WHERE condition;

Opérateurs de comparaisons particuliers :
Est égal à : =
Est égal à (valable pour NULL aussi) : <=>      --privilégier IS NULL ou IS NOT NULL
Intervalle : valeur BETWEEN val_inferieure AND val_supérieure   -- équivalent de valeur >= val_inferieure AND valeur <= val_supérieure   --peut s'utiliser avec nombres,textes et dates
Est inclus dans : valeur IN (...ensemble_de_possibilités);

Opérateurs mathématiques particuliers :
DIV : division entière

Opérateurs de logique : AND OR XOR NOT

Jokers (Regex)
'%'  : qui représente n’importe quelle chaîne de caractères, quelle que soit sa longueur (y compris une chaîne de longueur 0) 
'_'  : qui représente un seul caractère.

Exemples :
'b%'  cherchera toutes les chaînes de caractères commençant par 'b'  ("brocoli", "bouli", "b").
'b_'  cherchera toutes les chaînes de caractères contenant deux lettres dont la première est'b'  ("ba", "bf", "b8").

Il faut échapper les caractères de Jokers (avec \) si on souhaite les rechercher

Exemples utilisant les Jokers : 
Exclure une chaîne de caractères : ... WHERE nom NOT LIKE '%a%';
Recherche avec sensibilité à la casse : ... WHERE nom LIKE BINARY '%Lu%';

Index ↓    --exemple lors de la création de la table
.............................
    CREATE TABLE nom_table (
        id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
        colonne1 INT NOT NULL,   
        nom VARCHAR(30),
        commentaires TEXT,
        espece VARCHAR(40) DEFAULT 'Inconnue' NOT NULL,
        PRIMARY KEY (id),
        INDEX ind_nom (nom(10)),            -- Crée un index sur sur les 10 premières lettres du nom -- un index permet d’accélérer les requêtes de séléctions mais ralentit ceux de modifications/insertions/suppressions
        UNIQUE ind_uni_col1 (colonne1),     -- Crée un index UNIQUE -- Avoir un index UNIQUE sur une colonne (ou plusieurs) permet de s'assurer que jamais deux fois la même valeur est insérée
        FULLTEXT ind_full_com (commentaires),   -- Crée un index FULLTEXT -- Un index FULLTEXT  est utilisé pour faire des recherches de manière puissante et rapide sur un texte. (TEXT/VARCHAR/CHAR)
        UNIQUE ind_uni_nom_espece (nom, espece)  -- Index sur le nom et l'espece -- détail index sur plusieurs colonnes : https://bityl.co/5MDj
    )
    ENGINE=INNODB;
.............................
Ajout d’index après création de table : CREATE INDEX [type index] nom_index ON nom_table (...colonnes);  --autre façon : ALTER TABLE nom_table ADD TYPE_D_INDEX nom_index (...colonnes); -- ... ADD PRIMARY KEY (...colonnes); pour clé primaire
Suppression d’un index : ALTER TABLE nom_table DROP INDEX nom_index;        --... DROP PRIMARY KEY; pour supprimer clé primaire

FULLTEXT :
Un mot peut être composé de lettres, chiffres, tirets bas (_) et apostrophes (')
'-- Lorsque MySQL compare la chaîne de caractères que vous lui avez donnée et les valeurs dans votre table, il ne tient pas compte de tous les mots qu'il rencontre. Les règles sont les suivantes :
* les mots rencontrés dans au moins la moitié des lignes sont ignorés (règle des 50 %) ;
* les mots trop courts (moins de quatre lettres) sont ignorés ;
* les mots trop communs (en anglais, about, after, once, under, the…) ne sont également pas pris en compte.
Recherche naturelle ↓    --il suffit qu'un seul mot (mot exact) de la chaîne de caractères recherchée se retrouve dans une ligne pour que celle-ci apparaisse dans les résultats.
.............................
    SELECT *                                  -- Vous mettez évidemment les colonnes que vous voulez.
    FROM nom_table
    WHERE MATCH(...colonnes_voulues)          -- La (ou les) colonne(s) dans laquelle (ou lesquelles) on veut faire la recherche (index FULLTEXT correspondant nécessaire).
    AGAINST ('chaîne recherchée');            -- La chaîne de caractères recherchée, entre guillemets bien sûr.
.............................
Affichage de la pertinence de la recherche : SELECT *, MATCH(...colonnes_voulues) AGAINST ('chaîne recherchée') FROM nom_table;     --renvoie une table de pertinence qui est une valeur réelle supérieure à 0 si correspond à la recherche

Recherche booléenne ↓    --peut exiger que certains mots soient présents/absents, peut rechercher des parties de mot, pas de règle des 50 %, peut se faire sans FULLTEXT, résultat pas trié par pertinence par défaut
.............................
    ... --Un mot précédé par + : devra être présent, par - : devra être absent, un astérisque * en fin de mot indique qu'il peut finir de n'importe quelle manière
    AGAINST ('+petit* -prose' IN BOOLEAN MODE); 
.............................

Recherche avec extension de requête : Voir https://bityl.co/5MGj  --Les résultats d’une recherche naturelle sont utilisés pour faire en faire une seconde.

Clé primaire : c’est un index UNIQUE sur une colonne (ou plusieurs) qui ne peut pas être NULL
Clé étrangère: permet la vérification de l’intégrité de la BD. Elle doit être du même type que la clé primaire auquelle elle fait réference. Pas supporté par tous les moteurs de table (MyISAM ne supporte pas)
Ajout de clé étrangère à la création de la table: vers le bas de CREATE TABLE : CONSTRAINT nom_cle_etrangere FOREIGN KEY (...colonnes) REFERENCES table_référence(...colonnes_référence)
Ajout de clé étrangère après la création de la table: ALTER TABLE nom_table ADD CONSTRAINT nom_cle_etrangere FOREIGN KEY (...colonnes) REFERENCES table_référence(...colonnes_référence);
Suppression d’une clé étrangère : ALTER TABLE nom_table DROP FOREIGN KEY nom_cle_etrangere;

Contraintes :
Ajouter à la création d’une table ↓    --exemple
.............................
CREATE TABLE t1 (
  c1 int(11) DEFAULT NULL,
  c2 int(11) DEFAULT NULL,
  c3 VARCHAR(30) DEFAULT 'en_attente' NOT NULL,
  CONSTRAINT c1_c2_chk CHECK (((c1 + c2) < 9999)),
  CONSTRAINT c1_chk CHECK ((c1 > 0)),
  CONSTRAINT c3_chk CHECK (c3 IN ('en_attente', 'paye', 'recouvrement'))
) ENGINE=InnoDB
.............................
Ajouter après la création d’une table : ALTER TABLE nom_table ADD CONSTRAINT nom_contrainte CHECK (condition);

Définir un Alias : Exemple:  SELECT Espece.description AS description_espece        --peut aussi être utilisé pour écrire moin de code, ex : SELECT Espece.description AS d

Option sur suppression ou modification des clés étrangères :
Syntaxe ↓
................
    ALTER TABLE nom_table
    ADD [CONSTRAINT fk_col_ref]         
        FOREIGN KEY (colonne)            
        REFERENCES table_ref(col_ref)
        ON DELETE|UPDATE {RESTRICT | NO ACTION | SET NULL | CASCADE};  
................
RESTRICT ou NO ACTION : Même chose dans MySQL, comportement par défaut : si on essaye de supprimer/modifier une valeur référencée par une clé étrangère, l’action est avortée et on obtient une erreur.
SET NULL : NULL est substitué aux valeurs dont la référence est supprimée/modifiée.
CASCADE :  répercute la modification ou la suppression d’une référence de clé étrangère sur les lignes impactées.

Violation de contrainte d’unicité
Ignorer les erreurs : INSERT IGNORE INTO Espece (...) VALUES (...);     -- fonctionne de la même manière avec UPDATE
Supprimer les lignes qui gênent : REPLACE INTO Animal (...) VALUES (...);       -- remplace la ou les anciennes valeurs qui gênent par la ou les nouvelles valeurs
Modifier l’ancienne ligne ↓     -- si une contrainte d’unicité est violée par la requête d’insertion, la clause ON DUPLICATE KEY va aller modifier les colonnes spécifiées dans la ligne déjà existante
................
    INSERT INTO nom_table [(colonne1, colonne2, colonne3)]
    VALUES (valeur1, valeur2, valeur3)
    ON DUPLICATE KEY UPDATE colonne2 = valeur2 [, colonne3 = valeur3];
................

Les jointures permettent d’associer plusieurs tables entre elles en ayant en commun les ID de l’autre table.
Jointure Interne ↓      -- Pour sélectionner seulement les données qui ont une correspondance entre les deux tables
.............................
    SELECT ...colonnes  
    FROM nom_table1   
    INNER JOIN nom_table2                      -- INNER explicite le fait qu'il s'agit d’une jointure interne, mais c'est facultatif
        ON colonne_table1 = colonne_table2     -- sur quelles colonnes se fait la jointure
        [AND ...]
    [WHERE ...                               
    ORDER BY ...                               -- les clauses habituelles sont bien sûr utilisables !
    LIMIT ...]


    Exemple ↓ 

    SELECT Espece.id AS id_espece,                  
        Espece.description AS description_espece,          
        Animal.nom AS nom_bestiole                   
    FROM Espece   
    INNER JOIN Animal
        ON Espece.id = Animal.espece_id
    WHERE Animal.nom LIKE 'Ch%';
.............................

Jointure Externe ↓   -- on veut toutes les lignes de la table de gauche (sauf restrictions dans le WHERE), même si certaines n'ont pas de correspondance avec une ligne de la table de droite.
.............................
    ...         -- Similaire à une jointure interne sauf
    FROM nom_table1                                                  -- Table de gauche
    RIGHT JOIN nom_table2                                            -- Table de droite
        ON Animal.race_id = Race.id                                  -- récupère tout le contenu de la table de gauche même si il n'existe pas de contenu dans la table de droite qui corresponde
    ...
.............................

Jointures avec USING : SELECT * FROM table1 [INNER | LEFT | RIGHT] JOIN table2 USING (colonneJ);    --Lorsque les colonnes qui servent à joindre les deux tables ont le même nom, vous pouvez utiliser la clause USING  au lieu de la clause ON
Jointures naturelles : SELECT * FROM table1 NATURAL JOIN table2;        --Permet de déterminer automatiquement quelles colonnes joindre quand elles ont le même nom dans les deux tables

Sous requêtes ↓
................
    SELECT MIN(date_naissance)
    FROM (
        SELECT Animal.id, Animal.sexe, Animal.date_naissance, Animal.nom, Animal.espece_id
        FROM Animal
        INNER JOIN Espece
            ON Espece.id = Animal.espece_id
        WHERE sexe = 'F'
            AND Espece.nom_courant IN ('Tortue d''Hermann', 'Perroquet amazone')
    ) AS tortues_perroquets_F;      -- Il est obligatoire en MySQL de renommer les tables intermédiaires dans les FROM
................

Sous requêtes renvoyant une valeur ↓
................
    SELECT id, nom, espece_id
    FROM Race
    WHERE espece_id < (
        SELECT id    
        FROM Espece
        WHERE nom_courant = 'Tortue d''Hermann');   --la sous-requête renvoie la valeur 3 
................

Sous-requête renvoyant une ligne ↓
................
    SELECT id, sexe, nom, espece_id, race_id 
    FROM Animal
    WHERE ROW(id, race_id) = (      --renvoie le résultat quand Animal.id == Race.id et race_id == espece_id
        SELECT id, espece_id
        FROM Race
        WHERE id = 7);      --la sous-requête renvoie une seule ligne
................

Sous-requête renvoyant une colonne ↓
................
    SELECT *
    FROM Animal
    WHERE espece_id < ANY (     --espece_id doit être inférieur à au moins une des valeurs sélectionnées dans la sous-requête
        SELECT id
        FROM Espece
        WHERE nom_courant IN ('Tortue d''Hermann', 'Perroquet amazone')
    );
................
SOME : La même chose qu’ANY
ALL : Pour sélectionner les lignes de la table Animal, dont l’espece_id est inférieur à toutes les valeurs sélectionnées dans la sous-requête

Autres exemples sous-requêtes avec IN, NOT IN, ANY, SOME, ALL : bit.ly/3qSGqWX

Sous-requêtes corrélées ↓       --La sous-requête est corrélée à une requête dans un niveau supérieur à laquelle elle dépends si elle ne la trouve pas.
................
    SELECT colonne1 
    FROM tableA
    WHERE colonne2 IN (
        SELECT colonne3
        FROM tableB
        WHERE tableB.colonne4 = tableA.colonne5
        );
................

Conditions avec EXISTS et NOT EXISTS ↓      -- Une condition avec EXISTS  sera vraie (et donc la requête renverra quelque chose) si la sous-requête correspondante renvoie au moins une ligne.
................
    SELECT * FROM Race                      -- Exemple : on sélectionne toutes les races dont on ne possède aucun animal.
    WHERE NOT EXISTS (SELECT * FROM Animal WHERE Animal.race_id = Race.id);
................

Utilisation de sous requêtes pour la modification d’un tableau : bit.ly/3eM3AvG

Combiner les résultats de plusieurs requêtes : SELECT ... UNION [ALL] SELECT ...        //Sans ALL, l’union se fait en retirant les doublons dans la table finale

Fonctions scalaires : s’appliquent à chaque ligne indépendamment
ROUND(colonne[, décimales]) : Arrondit les valeurs de chaques lignes de la colonne 
CEIL(colonne) : arrondit au nombre entier supérieur
FLOOR(colonne) : arrondit au nombre entier inférieur
POW(colonne, exposant) : Exposant
SQRT(colonne) : racine carrée
ABS(colonne) : retourne la valeur absolue

UPPER(colonne) : convertir en majuscules 
LOWER(colonne) : convertir en minuscules
CHAR_LENGTH(colonne) : retourne le nombre de caractères de la chaîne
LENGTH(colonne) : compter le nombre d’octets de la chaîne, chaque caractère étant représenté par un ou plusieurs octets
STRCMP(chaine1, chaine2) : compare les deux chaînes et retourne 0 si elles sont les mêmes, -1 si la première chaîne est classée avant dans l’ordre alphabétique et 1 dans le cas contraire.
REPEAT(colonne, nombreDeFois) : Répéter une chaîne
LPAD(texte, long, caract) | RPAD(//) : retournent une chaîne en lui donnant une certaine longueur. Si la chaîne de départ est trop longue, elle sera raccourcie, sinon, des caractères seront ajoutés, à gauche pour LPAD(), à droite pour RPAD()
TRIM([[BOTH | LEADING | TRAILING] [caract] FROM] texte) : BOTH(défaut)|LEADING|TRAILING : cotés ou les chaines seront éliminés, caract : chaine à éliminer (défaut: espaces blancs)
SUBSTRING(chaine, positionInitiale, longueur) : Récupérer une sous-chaîne
LOCATE(recherché, chaineInitiale) : retourne la position de la première occurrence d’une chaîne de caractères, si la chaine n’est pas trouvé, retourne 0, le premier char est à la position 1
REPLACE(chaine, ancienCaract, nouveauCaract) :  tous les caractères (ou sous-chaînes) ancCaract seront remplacés par nouvCaract.
CONCAT(chaine1, chaine2,…) : renvoie simplement une chaîne de caractères résultant de la concaténation de toutes les chaînes passées en paramètres.
FIELD(rech, chaine1, chaine2, chaine3,…) : recherche le premier argument (rech) dans les autres et retourne l’index auquel il est trouvé (0 si non trouvé)   Exemple pour trier : bit.ly/3cDTlXu
COALESCE(arg1, arg2, ...) : renvoie le premier argument non NULL

CAST(expr AS type) : Convertir le type de données   //exemple : SELECT CAST('870303' AS DATE);

autres fonctions numériques : https://bityl.co/3F77
autres fonctions sur chaines de caractères : https://bityl.co/3F79
autres fonctions sur dates et temps : https://bityl.co/3F9h

Fonctions d’agrégation (ou de groupement) : regroupent les lignes (par défaut, elles regroupent toutes les lignes en une seule)
AVG(colonne) : calculer la moyenne
SUM(colonne) : additionner les valeurs
MAX(colonne) : retourner la valeur maximale
MIN(colonne) : retourner la valeur minimale
COUNT(colonne) : compter le nombre d’entrées  --prends en argument * pour le nombre de rangées ou un nom de champs pour le nombre de rangées définies dans ce champ. Rajouter avant l'argument le mot clé DISTINCT pour avoir le nb d’arguments différents

GROUP_CONCAT([DISTINCT] col1 [, col2, ...] [ORDER BY col [ASC | DESC]] [SEPARATOR sep]) : renvoie une concaténation de toute les valeurs de la/les colonnes

Commandes utiles pour les fonctions d’agrégat :
GROUP BY : permet de grouper les données selon un ou certains champs. ex: SELECT AVG(prix), console FROM jeux_video GROUP BY console  --le prix moyen des jeux pour chaque console
-- Quand on fait un groupement avec GROUP BY, on ne peut sélectionner que deux types d’éléments : 1- une ou des colonnes ayant servi de critère pour le regroupement 2- une fonction d’agrégation (agissant sur n'importe quelle colonne).
-- les règles pour GROUPBY s'appliquent aussi pour ORDER BY
-- Utiliser GROUP BY colonne WITH ROLLUP pour ajouter le résultat de l'agrégat des sous-agrégats. ex: bit.ly/3tGyTwl
HAVING : filtrer les données après un regroupement. ex: SELECT AVG(prix) AS prix_moyen, console FROM jeux_video WHERE possesseur='Patrick' GROUP BY console HAVING prix_moyen <= 10
-- HAVING supporte des fonctions d’agrégats comme arguments, ex : HAVING COUNT(*) > 15;

Autres fonctions :
VERSION() : permettra de savoir sous quelle version de MySQL tourne votre serveur
CURRENT_USER() : renvoie l’utilisateur (et l’hôte) qui a été utilisé lors de l’identification au serveur
USER() : renvoie l’utilisateur (et l’hôte) qui a été spécifié lors de l’identification au serveur
LAST_INSERT_ID() : renvoie le dernier id créé par auto-incrémentation, pour la connexion utilisée
FOUND_ROWS() : permet d’afficher le nombre de lignes que votre dernière requête a rapportées        //pour obtenir le nombre trouvé sans prendre en compte LIMIT : bit.ly/3bYupuP

RAND() : retourne un nombre aléatoire       //exemple d’utilisation : SELECT * FROM Race ORDER BY RAND();

Transactions 
Quitter le mode autocommit : SET autocommit = 0;    //valable que pour la session courante  //On n’auras pas besoin de faire START TRANSACTION à chaque validation/annulation
Démarrer une transaction (avec mode autocommit activé): START TRANSACTION;      //MYSQL supporte aussi la synatxe BEGIN;
Valider une transaction : COMMIT;
Annuler une transaction : ROLLBACK;
Créer un jalon dans une transaction : SAVEPOINT nom_jalon; 
Annule les requêtes exécutées depuis un certain jalon : ROLLBACK TO nom_jalon; 
Retirer un certain jalon : RELEASE SAVEPOINT nom_jalon;     //n’annule ni ne valide les requêtes faites depuis

Commandes qui valident automatiquement une transaction et qui sont irréversibles ↓   //tout ce qui influe sur la structure de la base de données, et non sur les données elles-mêmes.
CREATE|DROP DATABASE, CREATE|ALTER|RENAME|DROP TABLE, CREATE|DROP INDEX, START TRANSACTION, LOAD DATA, LOCK|UNLOCK TABLES

Verrous         -- bloquer temporairement l'accès aux autres sessions, les tables verrouillés par une session seront les seules accessibles à celle-ci
Verrouiller une table : LOCK TABLES nom_table [AS alias_table] [READ | WRITE] [, ...];  -- READ pour autoriser la lecture, WRITE pour ne rien autoriser aux autres sessions mais autoriser l'écriture pour la session actuelle
Déverrouiller toute les tables : UNLOCK TABLES;
/* START TRANSACTION ôte les verrous de table (pas les verrous de ligne), Pour utiliser à la fois les transactions et les verrous de table, il faut utiliser le mode non-autocommit
   il faut appeler LOCK TABLES  avant toute modification de données, et de commiter/annuler les modifications avant d’exécuter UNLOCK TABLES */

Verrous de ligne
-- COMMIT et ROLLBACK relachent les verrous de ligne
Verrous partagés : permettent aux autres sessions de lire les données, mais pas de les modifier     -- on en pose lorsque l'on fait une requête dans le but de lire des données.
poser un verrou partagé : SELECT * FROM table WHERE condition LOCK IN SHARE MODE;     -- pose un verrou partagé sur les lignes indexées de la table pour lesquelles la condition est respectée (si non indexés, bloque toute la colonne)

Verrous exclusifs : ne permettent ni la lecture ni la modification des données   -- on en pose lorsque l'on fait une requête dans le but de lire des données.
-- Les requêtes d’insertion, de modification et de suppression des données posent automatiquement un verrou exclusif sur les lignes concernées
poser un verrou exclusif : SELECT * FROM table WHERE condition FOR UPDATE;  -- FOR UPDATE pose un verrou exclusif sur les lignes indexées de la table pour lesquelles la condition est respectée (si non indexés, bloque toute la colonne)

Niveau d’isolation   -- Paramètres pour définir le comportement des table vis à vis des verrous et des transactions
SET [GLOBAL | SESSION] TRANSACTION ISOLATION LEVEL { READ UNCOMMITTED | READ COMMITTED  | REPEATABLE READ (défaut) | SERIALIZABLE }
GLOBAL : définit le niveau d’isolation pour toutes les sessions MySQL qui seront créées dans le futur. Les sessions existantes ne sont pas affectées.
SESSION : définit le niveau d’isolation pour la session courante.
Rien : le niveau d’isolation défini ne concernera que la prochaine transaction que l’on ouvrira dans la session courante.
READ COMMITTED : un SELECT  verra toujours les derniers changements commités, même s’ils ont été faits dans une autre session, après le début de la transaction.
READ UNCOMMITTED : une session sera capable de lire des changements encore non commités par d’autres sessions.
REPEATABLE READ : si l’on fait plusieurs requêtes de sélection (non verrouillantes) à la suite dans une transaction, elles donneront toujours le même résultat, quels que soient les changements effectués par d’autres sessions.
SERIALIZABLE : se comporte comme REPEATABLE READ, sauf que, lorsque le mode autocommit est désactivé, tous les SELECT  simples sont implicitement convertis en SELECT ... LOCK IN SHARE MODE

Créer ou modifier une variable utilisateur : SET @nomVariable := valeur;  --supporte int, float, string et binaire --dans un SELECT : SELECT @poids := 48.15 -- Une variable utilisateur n'existe que pour la session dans laquelle elle a été définie.

Requête préparée        -- fonctions qui ne sont gardées en mémoire que pour la session courante -- on utilise généralement un autre language de programmation plutot que de les faire directement sur MySQL
Définir une requête préparée : ex : PREPARE nom_requete FROM 'SELECT * FROM Table WHERE email = ?';  -- ? représente les paramètres qu'on renteras dansla requête (peuvent seulement être des valeurs)
Requête préparée avec CONCAT : SET @req_animal = CONCAT('SELECT ', @colonne, ' FROM Animal WHERE id = ?'); PREPARE select_col_animal FROM @req_animal;  -- permet de personnaliser plus que des valeurs 
Exécuter une requête préparée : EXECUTE nom_requete [USING @parametre1, @parametre2, ...];      -- les paramètres doivent nécessairement être des variables utilisateur (pas possible de rentrer directement une valeur)
Supprimer une requête préparée : DEALLOCATE PREPARE nom_requete;

Procédure stockée       -- stockées de manière durable -comme les tables- et supportent un bloc d’instructions  -- les utiliser permet un gain de performance
types de paramètres : 
IN (défaut): paramètre dont la valeur est fournie à la procédure stockée
OUT:  paramètre "sortant", dont la valeur sera établie au cours de la procédure et qui pourra ensuite être utilisé en dehors de cette procédure.
INOUT : un tel paramètre sera utilisé pendant la procédure, verra éventuellement sa valeur modifiée par celle-ci, et sera ensuite utilisable en dehors.
Créer une procédure stockée ↓
................        --exemple
    DELIMITER |
    CREATE PROCEDURE afficher_race (IN p_espece_id INT, OUT var1, OUT var2, INOUT p_prix DECIMAL(7,2))  
    BEGIN
        SELECT nom, espece_id, p_prix + 5 INTO var1, var2, p_prix  -- on rentre la valeur de nom dans var1, espece_id dans var2 et p_prix +5 dans p_prix (SELECT ne doit retourner qu'une seule ligne)
        FROM Race
        WHERE espece_id = p_espece_id;  -- Utilisation du paramètre
    END |
    DELIMITER ;  -- On remet le délimiteur par défaut          
................
Appeler une procédure stockée : CALL afficher_races(@espece_id, @nom, @espece_id);        -- on peut aussi mettre une valeur directement pour les paramètres de type IN
Supprimer une procédure : DROP PROCEDURE afficher_races;

Déclarer une variable locale : DECLARE nom_variable type_variable [DEFAULT valeur_defaut];      -- ils n'existent que dans le bloc d’instructions dans lequel elles ont été déclarées.
Modifier une variable locale : SET nom_variable := valeur;

Structures conditionnelles
Structure if ↓
................
    IF (v_sexe = 'F') THEN      
        SELECT 'Je suis une femelle !' AS sexe;
    ELSEIF (v_sexe = 'M') THEN 
        SELECT 'Je suis un mâle !' AS sexe;
    ELSE                        
        SELECT 'Sexe indéfini...' AS sexe;
    END IF;
................

Structure case ↓
................
    CASE v_sexe
        WHEN 'F' THEN 
            SELECT 'Je suis une femelle !' AS sexe;
        WHEN 'M' THEN 
            SELECT 'Je suis un mâle !' AS sexe;
        ELSE         
            SELECT 'Sexe indéfini...' AS sexe;
    END CASE;
................

Bloc d’instructions vide : BEGIN END;

Utiliser une structure conditionnelle directement dans une requête ↓
................
    SELECT id, nom, CASE
            WHEN sexe = 'M' THEN 'Je suis un mâle !'
            WHEN sexe = 'F' THEN 'Je suis une femelle !'
            ELSE 'Je suis en plein questionnement existentiel...'
        END AS message
    FROM Animal
    WHERE id IN (9, 8, 6);
................

Opérateur ternaire : IF(condition, valeur_si_vrai, valeur_si_faux)   -- ex : SELECT nom, IF(sexe = 'M', 'Je suis un mâle', 'Je ne suis pas un mâle') AS sexe FROM Animal WHERE espece_id = 5;

Boucles
Boucle WHILE : WHILE condition DO  /*bloc d’instructions*/ END WHILE;
Boucle REPEAT : REPEAT  /*bloc d’instructions*/ UNTIL condition END REPEAT;  -- similaire au do while de Java mais arrête quand la la condition devient true
Boucle LOOP : LOOP instructions END LOOP      -- Boucle infinie à laquelle on sort en utilisant LEAVE

Nommer une boucle ou un bloc d’instructions : -- ex: nom_boucle: WHILE condition DO instructions END WHILE nom_boucle;  
Quitter manuellement une boucle ou un bloc d’instructions : LEAVE nom_bloc;
Déclencher une nouvelle itération de la boucle : ITERATE nom_boucle;        -- Cette instruction ne peut être utilisée que dans une boucle

Création d’un gestionnaire d’erreurs : DECLARE { EXIT | CONTINUE } HANDLER FOR { numero_erreur | SQLSTATE identifiant_erreur | ...conditions } /*bloc d’instructions*/
-- EXIT : provoque l'arrêt de la procédure
-- CONTINUE : la procédure est continuée après avoir géré l'erreur
-- Exemple de message d’erreur : ERROR 1062 (23000): Duplicate entry '21' for key 'ind_uni_animal_id’
-- 1062 est le numéro d’erreur MySQL
-- '23000' : l'identifiant de l'état SQL
+------------+----------+---------------------------------------------------------+
| Code MySQL | SQLSTATE | Description                                             |
+============+==========+=========================================================+
| 1048       | 23000    | La colonne x ne peut pas être NULL                      |
| 1169       | 23000    | Violation de contrainte d’unicité                       |
| 1216       | 23000    | Violation de clé secondaire : insertion ou modification |
|            |          | impossible (table avec la clé secondaire)               |
| 1217       | 23000    | Violation de clé secondaire : suppression ou            |
|            |          | modification impossible                                 |
|            |          | (table avec la référence de la clé secondaire)          |
| 1172       | 42000    | Plusieurs lignes de résultats alors que l’on ne peut en |
|            |          | avoir qu’une seule.                                     |
| 1242       | 21000    | La sous-requête retourne plusieurs lignes de résultats  |
|            |          | alors que l’on ne peut en avoir qu’une seule.           |
+------------+----------+---------------------------------------------------------+
Liste plus complète : bit.ly/2OVSUQu

Créer une coundition : DECLARE nom_erreur CONDITION FOR { SQLSTATE identifiant_SQL | numero_erreur_MySQL };  -- puis on utilise un gestionnaire : DECLARE EXIT HANDLER FOR nom_erreur
Conditions prédéfinies ↓
SQLWARNING  : tous les identifiants SQL commençant par '01', c’est-à-dire les avertissements et les notes
NOT FOUND  : tous les identifiants SQL commençant par '02'
SQLEXCEPTION  : tous les identifiants SQL ne commençant ni par '00', ni par '01', ni par '02', donc les erreurs

Lancer une exception : SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Custom error';

Curseurs   -- permettent de parcourir un jeu de résultats d’une requête SELECT, quel que soit le nombre de lignes récupérées, et d’en exploiter les valeurs.
           -- on déclare les curseurs après les variables locales et les conditions, mais avant les gestionnaires d’erreurs.
Déclaration d’un curseur : DECLARE nom_curseur CURSOR FOR requete_de_selection ;
Ouverture du curseur : OPEN nom_curseur;
Fermeture du curseur : CLOSE nom_curseur;
Parcours du curseur : FETCH nom_curseur INTO variable(s);   -- il faut donner autant de variables dans la clause INTO  que l'on a récupéré de colonnes dans la clause SELECT du curseur.
                                                            -- Chaque fois qu'on relance FETCH, la ligne suivante des résultats du SELECT est visée
Exemple de code pour parcourir toute les lignes d’une table avec un curseur : bit.ly/3c6CH3T
Exemple de code pour combiner la gestion d’erreur avec les transactions : bit.ly/3r3QeO0

Triggers
événement déclencheur : INSERT ou UPDATE ou DELETE     -- un trigger ne peut pas être déclenché par deux événements différents. On peut par contre créer plusieurs triggers par table pour couvrir chaque événement.
créer un trigger : CREATE TRIGGER nom_trigger BEFORE|AFTER INSERT|UPDATE|DELETE ON nom_table FOR EACH ROW corps_trigger;
supprimer un trigger : DROP TRIGGER nom_trigger;

convention nom trigger : nom_trigger = moment_evenement_table        -- ex: before_update_animal  pour un trigger BEFORE UPDATE ON Animal
-- Dans le corps du trigger, MySQL met à disposition deux mots-clés : OLD (pour DELETE et UPDATE) et NEW (pour INSERT et UPDATE)
OLD : les valeurs des colonnes de la ligne traitée avant qu’elle ne soit modifiée par l’événement déclencheur. Ces valeurs peuvent être lues, mais pas modifiées.
NEW : représente les valeurs des colonnes de la ligne traitée après qu’elle a été modifiée par l’événement déclencheur. Ces valeurs peuvent être lues et modifiées.
-- Exemple ↓
................
    -- Pour la commande INSERT INTO Adoption (client_id, animal_id, date_reservation, prix, paye) VALUES (12, 15, NOW(), 200.00, FALSE);
    -- Pour un trigger attaché à cette table et à cet évènement déclencheur :
        -- NEW.client_id  vaudra 12 ;
        -- NEW.animal_id  vaudra 15 ;
        -- NEW.date_reservation  vaudra NOW();
        -- NEW.date_adoption  vaudra NULL;
        -- NEW.prix  vaudra 200.00 ;
        -- NEW.paye  vaudra FALSE
................
-- Dans le cas d’une table transactionnelle, si une erreur est déclenchée, un ROLLBACK  sera fait.

-- Exemple implémentation de trigger ↓
................
    DELIMITER |
    CREATE TRIGGER after_insert_adoption AFTER INSERT
    ON Adoption FOR EACH ROW
    BEGIN
        UPDATE Animal
        SET disponible = FALSE
        WHERE id = NEW.animal_id;
    END |
    DELIMITER ;
................

-- Exemple implémentation de trigger pour historisation ↓
................
    DELIMITER |
    CREATE TRIGGER before_insert_race BEFORE INSERT
    ON Race FOR EACH ROW
    BEGIN
        SET NEW.date_insertion = NOW();
        SET NEW.utilisateur_insertion = CURRENT_USER();
        SET NEW.date_modification = NOW();
        SET NEW.utilisateur_modification = CURRENT_USER();
    END |

    CREATE TRIGGER before_update_race BEFORE UPDATE
    ON Race FOR EACH ROW
    BEGIN
        SET NEW.date_modification = NOW();
        SET NEW.utilisateur_modification = CURRENT_USER();
    END |
    DELIMITER ;
................
------------------------------------------------------- OLD

Les différents types de dates
DATE : stocke une date au format AAAA-MM-JJ (Année-Mois-Jour) ;
TIME : stocke un moment au format HH:MM:SS (Heures:Minutes:Secondes) ;
DATETIME : stocke la combinaison d’une date et d’un moment de la journée au format AAAA-MM-JJ HH:MM:SS. Ce type de champ est donc plus précis ;
TIMESTAMP : stocke le nombre de secondes passées depuis le 1er janvier 1970 à 00 h 00 min 00 s ;
YEAR : stocke une année, soit au format AA, soit au format AAAA.

Il n’est pas recommandé d’appeler un champs "date"
Exemple de sélection avec un date : SELECT pseudo, message, date FROM minichat WHERE date >= '2010-04-02 00:00:00' AND date <= '2010-04-18 00:00:00'   --on peut aussi utiliser BETWEEN 'date' AND 'date

Exemple d’utilisation de fonctions de date : SELECT pseudo, message, DAY(date) AS jour FROM minichat
Fonctions utiles: 
NOW() : renvoie le datetime actuel          -- ex: INSERT INTO minichat(pseudo, message, date) VALUES('Mateo', 'Message !', NOW())
CURDATE() : renvoie la date actuelle
CURTIME() : renvoie le time actuel
DAY(), MONTH(), YEAR() : extraire le jour, le mois ou l’année
HOUR(), MINUTE(), SECOND() : extraire les heures, minutes, secondes
DATE_FORMAT() : formater une date       --ex: SELECT pseudo, message, DATE_FORMAT(date, '%d/%m/%Y %Hh%imin%ss') AS date FROM minichat  --autres params possibles : https://bityl.co/3FAQ
DATE_ADD() et DATE_SUB() : ajouter ou soustraire des dates  --ex: SELECT pseudo, message, DATE_ADD(date, INTERVAL 2 MONTH) AS date_expiration FROM minichat --rajoute 2 mois au temps des entrées dates
CURRENT_TIMESTAMP : renvoie date et heure actuelle
