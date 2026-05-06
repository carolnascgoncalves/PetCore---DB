-------------------1----------------------
DROP TABLE tutor cascade constraints;
CREATE TABLE tutor(
ID_tut          NUMBER         PRIMARY KEY,     
NOME_tut        VARCHAR2(50)   NOT NULL,
DATA_NASC_tut   DATE           NOT NULL,
TEL_tut         CHAR(11)       NOT NULL,    -- TELEFONE
EMAIL_tut       VARCHAR2(40)   NOT NULL,
GENERO_tut      CHAR(1)        NOT NULL,
SENHA_tut       VARCHAR2(30)   NOT NULL
);
-------------------2----------------------
DROP TABLE pet cascade constraints;
CREATE TABLE pet(
ID_pet          NUMBER         PRIMARY KEY,
NOME_pet        VARCHAR2(50)   NOT NULL,
ESPECIE_pet     VARCHAR2(50)   NOT NULL,
RACA_pet        VARCHAR2(50)   NOT NULL,
DATA_NASC_pet   DATE           NOT NULL,
PELAGEM_pet     VARCHAR2(50)   NOT NULL,
PORTE_pet       VARCHAR2(20)   NOT NULL,
SEXO_pet        CHAR(1)        NOT NULL,
STATUS_pet      VARCHAR2(10)    
);
-------------------3----------------------
DROP TABLE tut_pet cascade constraints;
CREATE TABLE tut_pet(
ID_pet_fk       REFERENCES    pet,
ID_tut_fk       REFERENCES    tutor
);
-------------------4----------------------
DROP TABLE medico cascade constraints;
CREATE TABLE medico(
ID_med          NUMBER         PRIMARY KEY,
NOME_med        VARCHAR2(50)   NOT NULL,
DATA_NASC_med   DATE           NOT NULL,
TEL_med         CHAR(11)       NOT NULL,
EMAIL_med       VARCHAR2(40)   NOT NULL,
GENERO_med      CHAR(1)        NOT NULL,
ESPEC_med       VARCHAR2(100)  NOT NULL     -- ESPECIALIDADE
);
-------------------5----------------------
DROP TABLE historico cascade constraint;
CREATE TABLE historico(
ID_hist         NUMBER         PRIMARY KEY,
DATA_hist       DATE           NOT NULL,
STATUS_hist     VARCHAR(10)                 -- ATIVO ou INATIVO
);
-------------------6----------------------
DROP TABLE relatorio cascade constraints;
CREATE TABLE relatorio(
ID_rel          NUMBER         PRIMARY KEY,
ID_HIS_rel      REFERENCES     historico       NOT NULL,   -- HISTORICO DA QUAL ELE FOI FEITO
ID_MED_rel      REFERENCES     medico          NOT NULL    -- MEDICO RESPONSÁVEL 
);
-------------------7----------------------
DROP TABLE endereco cascade constraints;
CREATE TABLE endereco(
ID_end          NUMBER         PRIMARY KEY,
CEP_end         CHAR(8)        NOT NULL,
COMPL_end       VARCHAR2(200)              -- COMPLEMENTO
);

-------------------8-----------------------
DROP TABLE clinica cascade constraints;
CREATE TABLE clinica(
ID_cli          NUMBER         PRIMARY KEY,
CNPJ_cli        CHAR(14)       NOT NULL,
NOME_cli        VARCHAR2(50)   NOT NULL,
ID_ENDER_fk     REFERENCES     endereco        NOT NULL   -- ENDEREÇO DA CLINICA
);
-------------------9----------------------
DROP TABLE cli_rel cascade constraints;
CREATE TABLE cli_rel(
ID_cli          REFERENCES      clinica,
ID_rel          REFERENCES      relatorio
);
-------------------10---------------------
DROP TABLE exame cascade constraints;
CREATE TABLE exame(
ID_ex           NUMBER         PRIMARY KEY,
NOME_ex         VARCHAR2(50)   NOT NULL,
DATA_ex         DATE           NOT NULL,
TP_ex           VARCHAR(100)   NOT NULL,                  -- TIPO DO EXAME
ID_MED_fk       REFERENCES     medico         NOT NULL,   -- MEDICO RESPONSAVEL
ID_PET_fk       REFERENCES     pet            NOT NULL    -- PET VINCULADO
);
-------------------11---------------------
DROP TABLE receita cascade constraints;
CREATE TABLE receita(
ID_rec         NUMBER          PRIMARY KEY,
NOME_rec       VARCHAR2(50)    NOT NULL,
VAL_rec        DATE            NOT NULL,    -- VALIDADE
ID_MED_fk      REFERENCES      medico         NOT NULL,   -- MEDICO RESPONSAVEL
ID_PET_fk      REFERENCES      pet            NOT NULL    -- PET VINCULADO
);
-------------------12---------------------
DROP TABLE medicamento cascade constraints;
CREATE TABLE medicamento(
ID_medic       NUMBER          PRIMARY KEY,
NOME_medic     VARCHAR2(50)    NOT NULL,
DOSAGEM_medic  VARCHAR2(10)    NOT NULL,
INSTRC_medic   VARCHAR2(100)   NOT NULL     -- INSTRUÇÕES
);
-------------------13---------------------
DROP TABLE rec_medic cascade constraints;
CREATE TABLE rec_medic(
ID_rec_fk      REFERENCES      receita         NOT NULL,
ID_medic_fk    REFERENCES      medicamento     NOT NULL
);
-------------------14---------------------
DROP TABLE prontuario cascade constraints;
CREATE TABLE prontuario(
ID_pront       NUMBER          PRIMARY KEY,
DATA_pront     DATE            NOT NULL,
DESC_pront     VARCHAR(200),    
ID_PET_fk      REFERENCES      pet             NOT NULL,    -- PET VINCULADO
ID_tut_fk      REFERENCES      tutor           NOT NULL,    -- TUTOR RESPONSAVEL
ID_HIST_fk     REFERENCES      historico       NOT NULL,    -- HISTORICO A QUAL ELE VAI SER ENVIADO
ID_MED_rel     REFERENCES      medico          NOT NULL     -- MEDICO RESPONSÁVEL 
);
-- =========================================================








