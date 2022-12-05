prompt - Script de test : D�but
SET SERVEROUTPUT ON

prompt suppression des donn�es...
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
prompt Erreur : NomClient vide, une cha�ne compos�e uniquement d'espaces (2)
prompt Remarque : sous Oracle, une cha�ne vide '' est NULL alors que une cha�ne form�e d'espaces '   ' est NOT NULL
INSERT INTO Compte(NumCompte,NomClient,DateOuverture,Solde) VALUES (104,'      ',TO_DATE('04.12.21', 'DD.MM.YY'), 1000);
prompt Erreur : Solde n�gatif (1)
INSERT INTO Compte(NumCompte,NomClient,DateOuverture,Solde) VALUES (104,'DansLeRouge',TO_DATE('04.12.21', 'DD.MM.YY'), -100);

prompt Insertion dans Valeurs
prompt Insertion de 3 valeurs valides (2)
INSERT INTO Valeur(CodeValeur,Denomination,SecteurEconomique, Indice,Cours) VALUES ('EDF','EDF','Energies','SBF120',10);
INSERT INTO Valeur(CodeValeur,Denomination,SecteurEconomique, Indice,Cours) VALUES ('RNO','RENAULT','Automobile','CAC40',30);
INSERT INTO Valeur(CodeValeur,Denomination,SecteurEconomique, Indice,Cours) VALUES ('SAN','SANOFI','Pharmacie','CAC40',85);
prompt Erreur : Cours n�gatif (1)
INSERT INTO Valeur(CodeValeur,Denomination,SecteurEconomique, Indice,Cours) VALUES ('ATO','ATOS','Services','CAC40 ESG',-35);
prompt Insertion d'une valeur avec Indice null (1)
INSERT INTO Valeur(CodeValeur,Denomination,Cours) VALUES ('ATO','ATOS',35);

prompt Insertion des op�rations 'Achat' et 'Vente' et mise � jour automatique de Portefeuille
prompt Insertion de 10 op�rations valides (10)
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(101,'EDF',TO_DATE('01/10/21','DD/MM/YY'),'A',100,900);
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(101,'EDF',TO_DATE('15/10/21','DD/MM/YY'),'A',100,1000);
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(101,'RNO',TO_DATE('30/10/21','DD/MM/YY'),'A',50,1500);
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(102,'EDF',TO_DATE('10/10/21','DD/MM/YY'),'A',200,1800);
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(102,'EDF',TO_DATE('15/10/21','DD/MM/YY'),'V',100,1000);
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(102,'RNO',TO_DATE('01/12/21','DD/MM/YY'),'A',100,3200);
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(102,'RNO',TO_DATE('30/12/21','DD/MM/YY'),'V',100,3000);
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(103,'SAN',TO_DATE('30/11/21','DD/MM/YY'),'A',10,800);
prompt Erreur : DateOp inf�rieure ou �gale � DateOuverture (1)
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(103,'SAN',TO_DATE('30/10/21','DD/MM/YY'),'A',10,800);
prompt Erreur : DateOp sup�rieure � la date du jour (1)
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(103,'SAN',SYSDATE+1,'A',10,800);
prompt Erreur : QteOp n�gative ou nulle (1)
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(103,'SAN',TO_DATE('30/11/21','DD/MM/YY'),'A',-10,800);
prompt Erreur : Montant n�gatif (1)
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(103,'SAN',TO_DATE('30/11/21','DD/MM/YY'),'A',10,-800);
prompt Erreur : Montant 'Achat' sup�rieur au Solde (2)
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(103,'SAN',TO_DATE('30/11/21','DD/MM/YY'),'A',20,1800);
prompt Erreur : QteOp 'Vente' sup�rieure � Quantite du portefeuille (2)
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(103,'SAN',TO_DATE('30/12/21','DD/MM/YY'),'V',20,1800);
prompt Erreur : La valeur n'est pas dans le portefeuille ou 'vente � d�couvert' (2)
INSERT INTO Operation(NumCompte,CodeValeur,DateOp,Nature,QteOp,Montant) VALUES(103,'EDF',TO_DATE('30/12/21','DD/MM/YY'),'V',100,1000);

prompt Mise � jour du Cours d'une valeur et historisation...
prompt Alerter 'Prudent' et PMVL diminu�e pour la valeur 'EDF' (5)
UPDATE Valeur SET Cours=8.5 WHERE codeValeur='EDF';
prompt PMVL augment�e pour la valeur 'SANOFI' (5)
UPDATE Valeur SET Cours=90 WHERE codeValeur='SAN';

COMMIT;

prompt - Script de test : Fin