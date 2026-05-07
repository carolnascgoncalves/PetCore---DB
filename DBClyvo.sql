-------------------1----------------------
DROP TABLE tutor_petcore cascade constraints;
CREATE TABLE tutor_petcore(
ID_tut          NUMBER         PRIMARY KEY,
NOME_tut        VARCHAR2(100)  NOT NULL,
DATA_NASC_tut   DATE           NOT NULL,
TEL_tut         CHAR(11)       NOT NULL,    -- TELEFONE
EMAIL_tut       VARCHAR2(100)  NOT NULL,
SEXO_tut        CHAR(1)        NOT NULL,
SENHA_tut       VARCHAR2(30)   NOT NULL
);

-- 5 INSERTS NO TOTAL (fazer +4)
insert into tutor_petcore values(1, 'Sandra Nascimento', to_date('14-11-1968','DD-MM-YYYY'), '11952345123', 'sandraReg@gmail.com', 'F', 'senhaExemplo');

-------------------2----------------------
DROP TABLE historico_petcore cascade constraint;
CREATE TABLE historico_petcore(
ID_hist         NUMBER         PRIMARY KEY,
DATA_hist       DATE           NOT NULL,
STATUS_hist     VARCHAR(15)                 -- ATIVO (padrão) ou INATIVO
);

-- 10 INSERTS NO TOTAL (fazer +8)
insert into historico_petcore(id_hist, data_hist) values(1,  to_date('03-05-2026','DD-MM-YYYY')); -- ATIVO é o PADRAO
insert into historico_petcore(id_hist, data_hist, status_hist) values(2,  to_date('25-07-2025','DD-MM-YYYY'), 'INATIVO'); -- ATIVO é o PADRAO

-------------------3----------------------
DROP TABLE medico_petcore cascade constraints;
CREATE TABLE medico_petcore(
ID_med          NUMBER         PRIMARY KEY,
NOME_med        VARCHAR2(100)  NOT NULL,
DATA_NASC_med   DATE           NOT NULL,
TEL_med         CHAR(11)       NOT NULL,
EMAIL_med       VARCHAR2(100)  NOT NULL,
SEXO_med        CHAR(1)        NOT NULL,
SENHA_med       VARCHAR2(30)   NOT NULL,
ESPEC_med       VARCHAR2(200)  NOT NULL     -- ESPECIALIDADE
);

-- 5 INSERTS NO TOTAL (fazer +4)
insert into medico_petcore values(1, 'Renato Gonçalves', to_date('04-09-1980','DD-MM-YYYY'), '11857284924', 'renatoGon@gmail.com', 'M', 'senhaExemplo', 'Endocrinologia');

-------------------4----------------------
DROP TABLE pet_petcore cascade constraints;
CREATE TABLE pet_petcore(
ID_pet          NUMBER         PRIMARY KEY,
ID_hist_FK      REFERENCES     historico_petcore,
NOME_pet        VARCHAR2(100)  NOT NULL,
ESPECIE_pet     VARCHAR2(100)  NOT NULL,
RACA_pet        VARCHAR2(150)  NOT NULL,
DATA_NASC_pet   DATE           NOT NULL,
PELAGEM_pet     VARCHAR2(150)  NOT NULL,
PORTE_pet       VARCHAR2(25)   NOT NULL,
SEXO_pet        CHAR(1)        NOT NULL,
STATUS_pet      VARCHAR2(15)
);

-- 10 INSERTS NO TOTAL (fazer +9)
-- ATIVO é o padrão
insert into pet_petcore(ID_pet, ID_hist_FK, NOME_pet, ESPECIE_pet, RACA_pet, DATA_NASC_pet, PELAGEM_pet, PORTE_pet, SEXO_pet)
values(1, 1, 'Olimpio', 'Cachorro', 'Yorkshire', to_date('12-11-2006','DD-MM-YYYY'), 'Média amarronzada', 'Pequeno', 'M'); 


-------------------5----------------------
DROP TABLE tut_pet_petcore cascade constraints; -- tabela associativa de TUTOR e PET
CREATE TABLE tut_pet_petcore(
ID_pet_FK       REFERENCES     pet_petcore,
ID_tut_FK       REFERENCES     tutor_petcore
);
-- 10 INSERTS NO TOTAL (fazer +9) -> tenta ter uns tutores com 2 ou 3 pets
insert into tut_pet_petcore values(1, 1);

-------------------6----------------------
DROP TABLE relatorio_petcore cascade constraints;
CREATE TABLE relatorio_petcore(
ID_rel          NUMBER         PRIMARY KEY,
ID_HIS_FK       REFERENCES     historico_petcore       NOT NULL,   -- HISTORICO DA QUAL ELE FOI FEITO
ID_MED_FK       REFERENCES     medico_petcore          NOT NULL,   -- MEDICO RESPONSÁVEL 
OBS_rel         VARCHAR(500)                                       -- OBSERVAÇÃO 
);

-- 10 INSERTS NO TOTAL (fazer +9)
-- adicionar observação em alguns
insert into relatorio_petcore(ID_rel, ID_HIS_FK, ID_MED_FK) values(1, 1, 1);

-------------------7----------------------
DROP TABLE endereco_petcore cascade constraints;
CREATE TABLE endereco_petcore(
ID_end          NUMBER         PRIMARY KEY,
CEP_end         CHAR(8)        NOT NULL,
COMPL_end       VARCHAR2(200)              -- COMPLEMENTO
);

-- 5 INSERTS NO TOTAL (fazer +4)
-- adicionar complemento em alguns
insert into endereco_petcore(ID_end, CEP_end) values(1, '01001000');

-------------------8-----------------------
DROP TABLE clinica_petcore cascade constraints;
CREATE TABLE clinica_petcore(
ID_cli          NUMBER         PRIMARY KEY,
ID_ENDER_FK     REFERENCES     endereco_petcore        NOT NULL,  -- ENDEREÇO DA CLINICA
CNPJ_cli        CHAR(14)       NOT NULL,
NOME_cli        VARCHAR2(100)  NOT NULL
);

-- 5 INSERTS NO TOTAL (fazer +4)
-- TROCA O NOME DA CLINICA PFV
insert into clinica_petcore values(1, 1, '49582746381934', 'Clinica EXEMPLO'); 

-------------------9----------------------
DROP TABLE rel_cli_petcore cascade constraints;
CREATE TABLE rel_cli_petcore(
ID_rel          REFERENCES      relatorio_petcore,
ID_cli          REFERENCES      clinica_petcore
);

-- 5 INSERTS NO TOTAL (fazer +4)
insert into rel_cli_petcore values(1, 1);

-------------------10---------------------
DROP TABLE exame_petcore cascade constraints;
CREATE TABLE exame_petcore(
ID_ex           NUMBER         PRIMARY KEY,
ID_MED_FK       REFERENCES     medico_petcore         NOT NULL,   -- MEDICO RESPONSAVEL
NOME_ex         VARCHAR2(100)  NOT NULL,
DATA_ex         DATE           NOT NULL,
TP_ex           VARCHAR(100)   NOT NULL   -- TIPO DO EXAME
);

-- ENTRE 5 à 10 (alguns pets não terão, alguns terão mais que um)
insert into exame_petcore values(1, 1, 'Teste de Glicemia', to_date('07-01-2025','DD-MM-YYYY'), 'Exame endócrino');

-------------------11---------------------
DROP TABLE receita_petcore cascade constraints;
CREATE TABLE receita_petcore(
ID_rec         NUMBER          PRIMARY KEY,
ID_MED_FK      REFERENCES      medico_petcore        NOT NULL,   -- MEDICO RESPONSAVEL
NOME_rec       VARCHAR2(100)   NOT NULL,
VAL_rec        DATE            NOT NULL   -- VALIDADE
);

-- ENTRE 5 à 10 (alguns pets não terão, alguns terão mais que um)
insert into receita_petcore values(1, 1, 'Receita para controle hormonal', to_date('04-12-2026','DD-MM-YYYY'));

-------------------12---------------------
DROP TABLE medicamento_petcore cascade constraints;
CREATE TABLE medicamento_petcore(
ID_medic       NUMBER          PRIMARY KEY,
NOME_medic     VARCHAR2(100)   NOT NULL,
DOSAGEM_medic  VARCHAR2(15)    NOT NULL,
INSTRC_medic   VARCHAR2(200)   NOT NULL     -- INSTRUÇÕES
);

-- ENTRE 10 à 15 (algumas receitas terão uma, duas ou mais)
insert into medicamento_petcore values(1, 'Levotiroxina', '50mg', '1 Comprimido pela manhã');

-------------------13---------------------
DROP TABLE rec_medic_petcore cascade constraints; -- receita e medicamento
CREATE TABLE rec_medic_petcore(
ID_rec_FK      REFERENCES      receita_petcore         NOT NULL,
ID_medic_FK    REFERENCES      medicamento_petcore     NOT NULL
);

-- LEVA EM CONSIDERACAO A QUANTIDADE DE RECEITAS, E DECIDE QUANTOS MEDICAMENTOS POR RECEITA TERA 
insert into rec_medic_petcore values(1, 1);

-------------------14---------------------
DROP TABLE prontuario_petcore cascade constraints;
CREATE TABLE prontuario_petcore(
ID_pront       NUMBER          PRIMARY KEY,
ID_HIST_FK     REFERENCES      historico_petcore       NOT NULL,    -- HISTORICO A QUAL ELE VAI SER ENVIADO
ID_MED_FK      REFERENCES      medico_petcore          NOT NULL,    -- MEDICO RESPONSÁVEL 
DATA_pront     DATE            NOT NULL,
DESC_pront     VARCHAR(500)
);

-- ENTRE 5 A 10
insert into prontuario_petcore values(1, 1, 1, to_date('07-05-2026','DD-MM-YYYY'), 'Paciente apresentou alteração hormonal. Tratamento iniciado.');

-- =========================================================
delete from rel_cli_petcore;
delete from rec_medic_petcore;
delete from tut_pet_petcore;

delete from tutor_petcore;
delete from pet_petcore;
delete from relatorio_petcore;
delete from clinica_petcore;
delete from endereco_petcore;
delete from exame_petcore;
delete from receita_petcore;
delete from medicamento_petcore;
delete from prontuario_petcore;
delete from medico_petcore;
delete from historico_petcore;








