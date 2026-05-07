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
-------------------2----------------------
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
STATUS_pet      VARCHAR2(10)
);
-------------------3----------------------
DROP TABLE tut_pet_petcore cascade constraints;
CREATE TABLE tut_pet_petcore(
ID_pet_FK       REFERENCES     pet_petcore,
ID_tut_FK       REFERENCES     tutor_petcore
);
-------------------4----------------------
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
-------------------5----------------------
DROP TABLE historico_petcore cascade constraint;
CREATE TABLE historico_petcore(
ID_hist         NUMBER         PRIMARY KEY,
DATA_hist       DATE           NOT NULL,
STATUS_hist     VARCHAR(15)                 -- ATIVO ou INATIVO
);
-------------------6----------------------
DROP TABLE relatorio_petcore cascade constraints;
CREATE TABLE relatorio_petcore(
ID_rel          NUMBER         PRIMARY KEY,
ID_HIS_FK       REFERENCES     historico_petcore       NOT NULL,   -- HISTORICO DA QUAL ELE FOI FEITO
ID_MED_FK       REFERENCES     medico_petcore          NOT NULL,   -- MEDICO RESPONSÁVEL 
OBS_rel         VARCHAR(500)
);
-------------------7----------------------
DROP TABLE endereco_petcore cascade constraints;
CREATE TABLE endereco_petcore(
ID_end          NUMBER         PRIMARY KEY,
CEP_end         CHAR(8)        NOT NULL,
COMPL_end       VARCHAR2(200)              -- COMPLEMENTO
);

-------------------8-----------------------
DROP TABLE clinica_petcore cascade constraints;
CREATE TABLE clinica_petcore(
ID_cli          NUMBER         PRIMARY KEY,
ID_ENDER_FK     REFERENCES     endereco_petcore        NOT NULL,  -- ENDEREÇO DA CLINICA
CNPJ_cli        CHAR(14)       NOT NULL,
NOME_cli        VARCHAR2(100)  NOT NULL
);
-------------------9----------------------
DROP TABLE rel_cli_petcore cascade constraints;
CREATE TABLE rel_cli_petcore(
ID_rel          REFERENCES      relatorio_petcore,
ID_cli          REFERENCES      clinica_petcore
);
-------------------10---------------------
DROP TABLE exame_petcore cascade constraints;
CREATE TABLE exame_petcore(
ID_ex           NUMBER         PRIMARY KEY,
ID_MED_FK       REFERENCES     medico_petcore         NOT NULL,   -- MEDICO RESPONSAVEL
NOME_ex         VARCHAR2(100)  NOT NULL,
DATA_ex         DATE           NOT NULL,
TP_ex           VARCHAR(100)   NOT NULL   -- TIPO DO EXAME
);
-------------------11---------------------
DROP TABLE receita_petcore cascade constraints;
CREATE TABLE receita_petcore(
ID_rec         NUMBER          PRIMARY KEY,
ID_MED_FK      REFERENCES      medico_petcore        NOT NULL,   -- MEDICO RESPONSAVEL
NOME_rec       VARCHAR2(100)   NOT NULL,
VAL_rec        DATE            NOT NULL   -- VALIDADE
);
-------------------12---------------------
DROP TABLE medicamento_petcore cascade constraints;
CREATE TABLE medicamento_petcore(
ID_medic       NUMBER          PRIMARY KEY,
NOME_medic     VARCHAR2(100)   NOT NULL,
DOSAGEM_medic  VARCHAR2(15)    NOT NULL,
INSTRC_medic   VARCHAR2(200)   NOT NULL     -- INSTRUÇÕES
);
-------------------13---------------------
DROP TABLE rec_medic_petcore cascade constraints;
CREATE TABLE rec_medic_petcore(
ID_rec_FK      REFERENCES      receita_petcore         NOT NULL,
ID_medic_FK    REFERENCES      medicamento_petcore     NOT NULL
);
-------------------14---------------------
DROP TABLE prontuario_petcore cascade constraints;
CREATE TABLE prontuario_petcore(
ID_pront       NUMBER          PRIMARY KEY,
ID_HIST_FK     REFERENCES      historico_petcore       NOT NULL,    -- HISTORICO A QUAL ELE VAI SER ENVIADO
ID_MED_FK      REFERENCES      medico_petcore          NOT NULL,    -- MEDICO RESPONSÁVEL 
DATA_pront     DATE            NOT NULL,
DESC_pront     VARCHAR(500)
);
-- =========================================================








