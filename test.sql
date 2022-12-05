prompt - Script de test : Début
SET SERVEROUTPUT ON

prompt suppression des données...
DELETE FROM Portefeuille;
DELETE FROM Operation;
DELETE FROM Valeur;
DELETE FROM Compte;
DELETE FROM Historique;

prompt Insertion dans Compte
prompt Insertion de 3 comptes valides (2)
INSERT INTO Compte(NumCompte,NomClient,DateOuverture,Solde) VALUES (101,'Prudent',TO_DATE('10.09.21','DD.MM.YY'),5000);
INSERT INTO Compte(NumCompte,NomClient,DateOuverture,Solde) VALUES (102,'Trader',TO_DATE('02.10.21','DD.MM.YY'),10000);
INSERT INTO Compte(NumCompte,NomClient,DateOuverture,Solde) VALUES (103,'Trader',TO_DATE('03.11.21','DD.MM.YY'),2000);
prompt Erreur : NomClient vide, une chaîne composée uniquement d'espaces (2)
prompt Remarque : sous Oracle, une chaîne vide '' est NULL alors que une chaîne formée d'espaces '   ' est NOT NULL
INSERT INTO Compte(NumCompte,NomClient,DateOuverture,Solde) VALUES (104,'      ',TO_DATE('04.12.21', 'DD.MM.YY'), 1000);
prompt Erreur : Solde négatif (1)
INSERT INTO Compte(NumCompte,NomClient,DateOuverture,Solde) VALUES (104,'DansLeRouge',TO_DATE('04.12.21', 'DD.MM.YY'), -100);

prompt Insertion dans Valeurs
prompt Insertion de 3 valeurs valides (2)
INSERT INTO Valeur(CodeValeur,Denomination,SecteurEconomique, Indice,Cours) VALUES ('EDF','EDF','Energies','SBF120',10);
INSERT INTO Valeur(CodeValeur,Denomination,SecteurEconomique, Indice,Cours) VALUES ('RNO','RENAULT','Automobile','CAC40',30);
INSERT INTO Valeur(CodeValeur,Denomination,SecteurEconomique, Indice,Cours) VALUES ('SAN','SANOFI','Pharmacie','CAC40',85);
prompt Erreur : Cours négatif (1)
INSERT INTO Valeur(CodeValeur,Denomination,SecteurEconomique, Indice,Cours) VALUES ('ATO','ATOS','Services','CAC40 ESG',-35);
prompt Insertion d'une valeur avec Indice null (1)
INSERT INTO Valeur(CodeValeur,Denomination,Cours) VALUES ('ATO','ATOS',35);

prompt Insertion des opérations 'Achat' et 'Vente' et mise à jour automatique de Portefeuille
prompt Insertion de 10 opérations valides (10)
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(101,'EDF',TO_DATE('01/10/21','DD/MM/YY'),'A',100,900);
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(101,'EDF',TO_DATE('15/10/21','DD/MM/YY'),'A',100,1000);
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(101,'RNO',TO_DATE('30/10/21','DD/MM/YY'),'A',50,1500);
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(102,'EDF',TO_DATE('10/10/21','DD/MM/YY'),'A',200,1800);
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(102,'EDF',TO_DATE('15/10/21','DD/MM/YY'),'V',100,1000);
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(102,'RNO',TO_DATE('01/12/21','DD/MM/YY'),'A',100,3200);
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(102,'RNO',TO_DATE('30/12/21','DD/MM/YY'),'V',100,3000);
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(103,'SAN',TO_DATE('30/11/21','DD/MM/YY'),'A',10,800);
prompt Erreur : DateOp inférieure ou égale à DateOuverture (1)
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(103,'SAN',TO_DATE('30/10/21','DD/MM/YY'),'A',10,800);
prompt Erreur : DateOp supérieure à la date du jour (1)
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(103,'SAN',SYSDATE+1,'A',10,800);
prompt Erreur : QteOp négative ou nulle (1)
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(103,'SAN',TO_DATE('30/11/21','DD/MM/YY'),'A',-10,800);
prompt Erreur : Montant négatif (1)
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(103,'SAN',TO_DATE('30/11/21','DD/MM/YY'),'A',10,-800);
prompt Erreur : Montant 'Achat' supérieur au Solde (2)
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(103,'SAN',TO_DATE('30/11/21','DD/MM/YY'),'A',20,1800);
prompt Erreur : QteOp 'Vente' supérieure à Quantite du portefeuille (2)
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(103,'SAN',TO_DATE('30/12/21','DD/MM/YY'),'V',20,1800);
prompt Erreur : La valeur n'est pas dans le portefeuille ou 'vente à découvert' (2)
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(103,'EDF',TO_DATE('30/12/21','DD/MM/YY'),'V',100,1000);

prompt Mise à jour du Cours d'une valeur et historisation...
prompt Alerter 'Prudent' et PMVL diminuée pour la valeur 'EDF' (5)
UPDATE Valeur SET Cours=8.5 WHERE codeValeur='EDF';
prompt PMVL augmentée pour la valeur 'SANOFI' (5)
UPDATE Valeur SET Cours=90 WHERE codeValeur='SAN';

COMMIT;

prompt - Script de test : Fin