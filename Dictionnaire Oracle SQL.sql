Types de données Oracle: Officiel: https://bit.ly/3ab36LD w3r: tinyurl.com/y3w665pn fr: tinyurl.com/y6xegcrp

connexion db locale : usr: SYSTEM pass: root
connexion db locale en administrateur : dans le terminal : sqlplus /NOLOG   puis taper  CONNECT / AS SYSDBA 
démarrer  db locale : STARTUP
éteindre db locale : SHUTDOWN           -- Supporte des paramètres supplémentaires, voir bit.ly/3fXYPQ9

NUMBER(taille[,decimales]) : Nombre entier ou flottant
VARCHAR2 (taille) : texte jusqu’à 2000 caractères
LONG(taille) : texte pouvant être très long
DATE 'YYYY-MM-DD' : date (jour, mois, année).
TIMESTAMP 'YYYY-MM-DD hh:mm:ss' : Date et temps

Déclarer une variable du même type qu’une colonne : nom_variable TABLE.colonne%TYPE [:=val_initiale];
Déclarer une variable de type ligne (enregistrement) : nom_variable TABLE%ROWTYPE;
Déclarer une constante : nom_constante CONSTANT TYPE_DONNEE :=val_initiale;
Afficher un message : DBMS_OUTPUT.PUT_LINE('Message');
Lancer une exception : RAISE_APPLICATION_ERROR(code_erreur, message);       //-20 999 < code_erreur < -20 000

Créer trigger ↓     //2 exemples
................
    CREATE [OR REPLACE] TRIGGER trigger_name
    {BEFORE | AFTER } triggering_event ON table_name
    [FOR EACH ROW]
    [FOLLOWS | PRECEDES another_trigger]
    [ENABLE / DISABLE ]
    [WHEN condition]
    DECLARE
        declaration statements
    BEGIN
        executable statements
    EXCEPTION
        exception_handling statements
    END;

    CREATE OR REPLACE TRIGGER display_salary_changes 
    BEFORE DELETE OR INSERT OR UPDATE ON customers 
    FOR EACH ROW 
    WHEN (NEW.ID > 0) 
    DECLARE 
        sal_diff number; 
    BEGIN 
        sal_diff := :NEW.salary  - :OLD.salary; 
        dbms_output.put_line('Old salary: ' || :OLD.salary); 
        dbms_output.put_line('New salary: ' || :NEW.salary); 
        dbms_output.put_line('Salary difference: ' || sal_diff); 
    END; 
    / 

    CREATE OR REPLACE TRIGGER t
    BEFORE
        INSERT OR
        UPDATE OF salary, department_id OR
        DELETE
    ON employees
    BEGIN
        CASE
            WHEN INSERTING THEN
                DBMS_OUTPUT.PUT_LINE('Inserting');
            WHEN UPDATING('salary') THEN
                DBMS_OUTPUT.PUT_LINE('Updating salary');
            WHEN UPDATING('department_id') THEN
                DBMS_OUTPUT.PUT_LINE('Updating department ID');
            WHEN DELETING THEN
                DBMS_OUTPUT.PUT_LINE('Deleting');
        END CASE;
    END;
    /
................

Dans les triggers, les pseudo-enregistrements sont :OLD et :NEW
Déclarer un curseur : CURSOR cursor_name IS SELECT_statement;
Vérifier si il reste des lignes dans le curseur : nom_curseur%NOTFOUND;     -- retourne un "booléen"

Créer une fonction ↓
................
    CREATE OR REPLACE FUNCTION nomFonction[ (déclarationParam[,déclarationParam…]) ]
    RETURN typeRetour { IS | AS }
        [déclarationVar;            -- variables qu'on va retourner
        [déclarationVar;] …]
    BEGIN
        instructions
        [EXCEPTION
        énoncéException
        [énoncéException]…]
    END;
    /

    CREATE OR REPLACE FUNCTION f_nb_films_dans_cat (
        id_categorie_donne categorie.id_categorie%TYPE
    ) RETURN NUMBER IS
        nombre_films_dans_cat NUMBER;

    BEGIN
        SELECT COUNT(imdb_id)
        INTO nombre_films_dans_cat
        FROM film
        WHERE id_categorie = id_categorie_donne;

        RETURN nombre_films_dans_cat;
    END;
    /
................

Tester fonction : SELECT nom_fonction(45) from DUAL;        -- DUAL est une pseudo table spéciale

Créer une procédure ↓
................
    CREATE OR REPLACE PROCEDURE nomProcédure
    [ (déclarationParam[,déclarationParam…]) ]
    { IS | AS }
        [déclarationVar;
        [déclarationVar;] …]
    BEGIN
        instructions
    [EXCEPTION
        énoncéException
        [énoncéException]…]
    END;
    /

    CREATE OR REPLACE PROCEDURE p_Emettre_Factures (
        p_espece_id IN coupon.montant%TYPE, 
        OUT var1, 
        p_prix INOUT DECIMAL(7,2)
    ) IS 
    montant_factures NUMBER;

    BEGIN
        SELECT nom, espece_id, p_prix + 5 
        INTO var1, var2, p_prix
        FROM Race
        WHERE espece_id = p_espece_id;

        UPDATE client
        SET client.montant_a_payer = montant_factures
        WHERE client.id_client = client_id;
    END;
................

Exemple curseur implicite ↓
................
    BEGIN
        FOR un_enregistrement IN 
        ( 
            SELECT *
            FROM Produit
            WHERE cout > 1000
        )
        LOOP
            DBMS_OUTPUT.PUT_LINE(un_enregistrement.desc_produit);
        END LOOP;
    END;
................

Exceptions prédéfinies les plus utilisées :
INVALID_NUMBER: La conversion d’une chaine de caractères en un nombre n’a pas fonctionné (ex.: la chaine ne contenait pas un nombre)
NO_DATA_FOUND: Une requête de type SELECT…INTO n’a retourné aucune valeur (donc l’affectation ne peut fonctionner)
TOO_MANY_ROWS: Une requête de type SELECT…INTO retourne plus d’une ligne
ZERO_DIVIDE: Une opération de division par 0 a eu lieu.

Gérer une exception exemple ↓
................
    BEGIN
        ...
        EXCEPTION
        WHEN nom_de_l_exception1 THEN
        ...                                 -- instructions si l’exception nom_de_l_exception1 se produit
        WHEN nom_de_l_exception1 THEN
        ....                                -- instructions si l’exception nom_de_l_exception2 se produit
        WHEN OTHERS THEN
        ...                                 -- instructions si un autre type d’exception se produit
    END;

    -- Exemple avec valeurs
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No de sortie introuvable!');
        RETURN 0;
................

Lancer une exception exemple ↓
................
    CREATE OR REPLACE FUNCTION f_moyenne_sorties ( le_produit Produit.code_produit%TYPE)
    RETURN NUMBER IS
        la_moyenne NUMBER(10,2);
        E_AUCUNE_SORTIE EXCEPTION;          -- déclaration
    BEGIN
        SELECT AVG(cout*Sortie.quantite)
        INTO la_moyenne
        FROM Sortie
        JOIN Produit ON Sortie.code_produit = Produit.code_produit
        WHERE Sortie.code_produit = le_produit;

        IF la_moyenne IS NULL THEN
            RAISE E_AUCUNE_SORTIE;          -- lancement
        END IF;

        RETURN la_moyenne;

        EXCEPTION
            WHEN E_AUCUNE_SORTIE THEN       -- attraper
            RETURN 0;
    END;
................

Conventions de nommage :
variables : snail_case
procédures : ex: p_Salaire_Moyen
fonctions : ex: f_Salaire_Moyen
curseurs : ex : cur_liste_produits
exceptions : ex : E_PRODUIT_INTROUVABLE

Conventions de commentaire :
Dans une fonction/procédure : Chaque entrée dans la zone de déclarations (variables, curseurs, exceptions) doit être commentée en expliquant sa raison d’exister

Autres convetions :
Les instructions suivantes déclarent des sous-bloc, et ils doivent être indentés : DECLARE, IS, BEGIN, EXCEPTION, THEN, ELSE, LOOP

______________________________
Oracle JDBC
------------------------------

Établir une connexion ↓
................
    import java.sql.*;
    ...
    Connection connJdbc;
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        connJdbc = DriverManager.getConnection("jdbc:oracle:thin:@URL_SERVEUR:NUM_PORT:SID", "USERNAME", "MOTDEPASSE");
    } catch (ClassNotFoundException | SQLException e){
        e.printStackTrace();
    }
................

Créer une requête : Statement requete = connJdbc.createStatement();
Exécuter une requête : ResultSet resultats = requete.executeQuery("SELECT * From Sortie WHERE code_produit='R47'");
Parcourir résultats d'une requête : while(resultats.next()){ System.out.println( resultats.getInt("quantite"); }

Créer une requête préparée : PreparedStatement requete = connJdbc.prepareStatement("SELECT * FROM Produit WHERE classe = ? AND quantite = ?");  -- ? sont les paramètres
Spécifier la valeur des paramètres d'une requête préparée : requete.setString(1, "A10");       //on met le premier ? à "A10"
Exécuter une requête préparée : ResultSet resultats = requete.executeQuery();
Exécution par lot ↓
................
    PreparedStatement requete = connJdbc.prepareStatement("INSERT INTO Produit (classe, quantite) VALUES (?,?)");
    requete.setString( 1, "A10");
    requete.setInt( 2, 25 );
    requete.addBatch();

    requete.setString( 1, "A45");
    requete.setInt( 2, 34 );
    requete.addBatch();

    requete.executeBatch();
................

Exécuter une requête de modification de données : int nbAffectees = requete.executeUpdate("DELETE FROM Sortie WHERE code_produit='R47'");
Gestion des transactions ↓
................
    connJdbc.setAutoCommit(false);
    connJdbc.commit();
    connJdbc.rollback();
................





