-- ======================   TABELAS   ======================
-------------------1----------------------
DROP TABLE tutor_petcore cascade constraints;
CREATE TABLE tutor_petcore(
ID_tut          NUMBER         PRIMARY KEY,
NOME_tut        VARCHAR2(100)  NOT NULL,
DATA_NASC_tut   DATE           NOT NULL,
TEL_tut         VARCHAR2(11)   NOT NULL,    -- TELEFONE
EMAIL_tut       VARCHAR2(100)  NOT NULL,
SEXO_tut        CHAR(1)        NOT NULL,
SENHA_tut       VARCHAR2(30)   NOT NULL
);

-------------------2----------------------
DROP TABLE historico_petcore cascade constraint;
CREATE TABLE historico_petcore(
ID_hist         NUMBER         PRIMARY KEY,
DATA_hist       DATE           NOT NULL,
STATUS_hist     VARCHAR(15)                 -- ATIVO (padrão) ou INATIVO
);

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
STATUS_pet      VARCHAR2(15)   NOT NULL
);

-------------------5----------------------
DROP TABLE tut_pet_petcore cascade constraints; -- tabela associativa de TUTOR e PET
CREATE TABLE tut_pet_petcore(
ID_pet_FK       REFERENCES     pet_petcore,
ID_tut_FK       REFERENCES     tutor_petcore,

PRIMARY KEY(ID_pet_FK, ID_tut_FK)
);

-------------------6----------------------
DROP TABLE relatorio_petcore cascade constraints;
CREATE TABLE relatorio_petcore(
ID_rel          NUMBER         PRIMARY KEY,
ID_HIS_FK       REFERENCES     historico_petcore       NOT NULL,   -- HISTORICO DA QUAL ELE FOI FEITO
ID_MED_FK       REFERENCES     medico_petcore          NOT NULL,   -- MEDICO RESPONSÁVEL 
OBS_rel         VARCHAR2(500)                                       -- OBSERVAÇÃO 
);

----------------7----------------------
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
ID_rel_FK          REFERENCES      relatorio_petcore,
ID_cli_FK          REFERENCES      clinica_petcore,

PRIMARY KEY(ID_rel_FK, ID_cli_FK)
);

-------------------10---------------------
DROP TABLE exame_petcore cascade constraints;
CREATE TABLE exame_petcore(
ID_ex           NUMBER         PRIMARY KEY,
ID_MED_FK       REFERENCES     medico_petcore         NOT NULL,   -- MEDICO RESPONSAVEL
NOME_ex         VARCHAR2(100)  NOT NULL,
DATA_ex         DATE           NOT NULL,
TP_ex           VARCHAR2(100)  NOT NULL   -- TIPO DO EXAME
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
DROP TABLE rec_medic_petcore cascade constraints; -- receita e medicamento
CREATE TABLE rec_medic_petcore(
ID_rec_FK      REFERENCES      receita_petcore         NOT NULL,
ID_medic_FK    REFERENCES      medicamento_petcore     NOT NULL,

primary key(ID_rec_FK, ID_medic_FK)
);

-------------------14---------------------
DROP TABLE prontuario_petcore cascade constraints;
CREATE TABLE prontuario_petcore(
ID_pront       NUMBER          PRIMARY KEY,
ID_HIST_FK     REFERENCES      historico_petcore       NOT NULL,    -- HISTORICO A QUAL ELE VAI SER ENVIADO
ID_MED_FK      REFERENCES      medico_petcore          NOT NULL,    -- MEDICO RESPONSÁVEL 
DATA_pront     DATE            NOT NULL,
DESC_pront     VARCHAR2(500)
);

-- ======================   PROCEDURE'S   ======================
set serveroutput on;

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

DROP TABLE log_petcore cascade constraints;
create table log_petcore(
ID_log          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
NOME_PROC_log   VARCHAR2(200)  NOT NULL,
NOME_log        VARCHAR2(100)  NOT NULL,
DATA_log        DATE           NOT NULL,
COD_log         VARCHAR2(50)   NOT NULL,
MSG_log         VARCHAR2(300)  NOT NULL
);

-------------------  TUTOR  -------------------
create or replace procedure inserir_dados_tutor(
ID_tut              IN NUMBER,
NOME_tut            IN VARCHAR2,
DATA_NASC_tut       IN DATE,          
TEL_tut             IN VARCHAR2,      
EMAIL_tut           IN VARCHAR2, 
SEXO_tut            IN CHAR,    
SENHA_tut           IN VARCHAR2
)
is
    V_MSG_log       VARCHAR2(300);
    V_COD_log       VARCHAR2(50);
    tel_excedente   EXCEPTION;
    sexo_excedente  EXCEPTION;
    senha_excedente EXCEPTION;
    dupl_erro      EXCEPTION;
    
    PRAGMA EXCEPTION_INIT(dupl_erro, -1);
begin
    if(length(TEL_tut) != 11) then
        RAISE tel_excedente;
    
    elsif(length(SEXO_tut) != 1) then
        RAISE sexo_excedente; 
    
    elsif(length(SENHA_tut) > 30 or length(SENHA_tut) < 8) then
        RAISE senha_excedente; 
    end if;

    insert into tutor_petcore values(ID_tut, NOME_tut, DATA_NASC_tut, TEL_tut, EMAIL_tut, SEXO_tut, SENHA_tut);
    dbms_output.put_line('Dado inserido na tabela TUTOR com sucesso!');

    
EXCEPTION     
    when dupl_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela TUTOR. Essa entidade já existe';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_tutor');

    WHEN tel_excedente then
        V_MSG_log := 'ERRO ao adicionar dado na tabela TUTOR. "Telefone" Deve conter 11 caracteres';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_tutor');

        
    WHEN sexo_excedente then
        V_MSG_log := 'ERRO ao adicionar dado na tabela TUTOR. "Sexo" deve conter entre 1 caracter';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_tutor');
        
    WHEN senha_excedente then
        V_MSG_log := 'ERRO ao adicionar dado na tabela TUTOR. "Senha" deve conter entre 8 à 30 caracteres';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_tutor');
    
    WHEN others then
        V_MSG_log := 'ERRO ao adicionar dado na tabela TUTOR. Confira os dados novamente';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_tutor');
     
end;
/


exec inserir_dados_tutor(1, 'Sandra Nascimento', to_date('14-11-1968','DD-MM-YYYY'), '11992746375', 'sandraReg@gmail.com', 'F', '523453466256');
exec inserir_dados_tutor(2, 'Noelle Almeida', to_date('18-05-1988','DD-MM-YYYY'), '11992746375', 'Nolal@gmail.com', 'F', '2445356ghd5');
exec inserir_dados_tutor(3, 'Lucia Lurdes', to_date('23-04-1993','DD-MM-YYYY'), '11993857635', 'lulu.lurdes@gmail.com', 'F', '233453564fghj');
exec inserir_dados_tutor(4, 'Mario Barros', to_date('27-08-2008','DD-MM-YYYY'), '11993627104', 'mariooo324@gmail.com', 'M', 'maa933452847');
exec inserir_dados_tutor(5, 'Luis Alfredo', to_date('14-11-1990','DD-MM-YYYY'), '11903725364', 'lui98437@gmail.com', 'M', '92384792745');



-------------------  HISTORICO  -------------------
create or replace procedure inserir_dados_historico(
ID_hist           IN VARCHAR2,
DATA_hist         IN DATE,
STATUS_hist       IN VARCHAR2    
)
is
    V_ID          NUMBER;
    V_MSG_log     VARCHAR2(300);
    V_COD_log     VARCHAR2(50);
    id_erro       EXCEPTION;
    status_exc    EXCEPTION;
    dupl_erro     EXCEPTION;
    
    PRAGMA EXCEPTION_INIT(dupl_erro, -1);
    
begin
    V_ID := TO_NUMBER(ID_hist); -- tenta transformar o ID em número, se der erro vai cair no exception

    if(not(UPPER(STATUS_hist) = 'ATIVO') and not(UPPER(STATUS_hist) = 'INATIVO')) then
        RAISE status_exc;
    end if;

    insert into historico_petcore(id_hist, data_hist, status_hist) values(V_ID, DATA_hist, STATUS_hist); 
    dbms_output.put_line('Dado inserido na tabela HISTORICO com sucesso!');
EXCEPTION
    when dupl_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela HISTORICO. Essa entidade já existe';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_historico');

    when VALUE_ERROR then
        V_MSG_log := 'ERRO ao adicionar dado na tabela HISTORICO. "Id" Deve ser um número';
        V_COD_log := TO_CHAR(SQLCODE);
        
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_historico');
    
    when status_exc then
        V_MSG_log := 'ERRO ao adicionar dado na tabela HISTORICO. "Status" Deve ser "ativo" ou "inativo"';
        V_COD_log := TO_CHAR(SQLCODE);
        
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_historico');

    WHEN others then
        V_MSG_log := 'ERRO ao adicionar dado na tabela HISTORICO. Confira os dados novamente';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_historico');
end;
/


exec inserir_dados_historico(1,  to_date('03-05-2026','DD-MM-YYYY'), 'INATIVO'); 
exec inserir_dados_historico(2,  to_date('25-07-2025','DD-MM-YYYY'), 'INATIVO');
exec inserir_dados_historico(3,  to_date('09-02-2026','DD-MM-YYYY'), 'ATIVO');
exec inserir_dados_historico(4,  to_date('19-05-2026','DD-MM-YYYY'), 'ATIVO');
exec inserir_dados_historico(5,  to_date('01-03-2026','DD-MM-YYYY'), 'ATIVO');
exec inserir_dados_historico(6,  to_date('15-07-2025','DD-MM-YYYY'), 'INATIVO');
exec inserir_dados_historico(7,  to_date('20-08-2025','DD-MM-YYYY'), 'INATIVO');
exec inserir_dados_historico(8,  to_date('16-10-2025','DD-MM-YYYY'), 'INATIVO');
exec inserir_dados_historico(9,  to_date('03-01-2026','DD-MM-YYYY'), 'ATIVO');
exec inserir_dados_historico(10,  to_date('03-02-2026','DD-MM-YYYY'),'ATIVO');



-------------------  MEDICO  -------------------
create or replace procedure inserir_dados_medico(
ID_med          IN NUMBER,
NOME_med        IN VARCHAR2,
DATA_NASC_med   IN DATE,
TEL_med         IN CHAR,
EMAIL_med       IN VARCHAR2,
SEXO_med        IN CHAR,
SENHA_med       IN VARCHAR2,
ESPEC_med       IN VARCHAR2  
)
is
    V_MSG_log       VARCHAR2(300);
    V_COD_log       VARCHAR2(50);
    tel_excedente   EXCEPTION;
    sexo_excedente  EXCEPTION;
    senha_excedente EXCEPTION;
    dupl_erro       EXCEPTION;
    
    PRAGMA EXCEPTION_INIT(dupl_erro, -1);
begin
    if(length(TEL_med) != 11) then
        RAISE tel_excedente;
    
    elsif(length(SEXO_med) != 1) then
        RAISE sexo_excedente; 
    
    elsif(length(SENHA_med) > 30 or length(SENHA_med) < 8) then
        RAISE senha_excedente; 
    end if;

    insert into medico_petcore(ID_med, NOME_med, DATA_NASC_med, TEL_med, EMAIL_med, SEXO_med, SENHA_med, ESPEC_med)
        values(ID_med, NOME_med, DATA_NASC_med, TEL_med, EMAIL_med, SEXO_med, SENHA_med, ESPEC_med);
    dbms_output.put_line('Dado inserido na tabela MEDICO com sucesso!');
    
EXCEPTION
    when dupl_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela MEDICO. Essa entidade já existe';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_medico');

    WHEN tel_excedente then
        V_MSG_log := 'ERRO ao adicionar dado na tabela MEDICO. "Telefone" Deve conter 11 caracteres';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_medico');

        
    WHEN sexo_excedente then
        V_MSG_log := 'ERRO ao adicionar dado na tabela MEDICO. "Sexo" deve conter entre 1 caracter';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_medico');
        
    WHEN senha_excedente then
        V_MSG_log := 'ERRO ao adicionar dado na tabela MEDICO. "Senha" deve conter entre 8 à 30 caracteres';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_medico');
    
    WHEN others then
        V_MSG_log := 'ERRO ao adicionar dado na tabela MEDICO. Confira os dados novamente';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_medico');
end;
/


exec inserir_dados_medico(1, 'Renato Gonçalves', to_date('04-09-1990','DD-MM-YYYY'), '11857284924', 'renatoGon@gmail.com', 'M', '08945706', 'Endocrinologia');
exec inserir_dados_medico(2, 'Julio Juniro', to_date('08-02-1986','DD-MM-YYYY'), '11883746219', 'JU9836247@gmail.com', 'M', '439857$%', 'Cardiologia');
exec inserir_dados_medico(3, 'Rafael Gomes', to_date('02-05-1978','DD-MM-YYYY'), '11983647515', 'RAFAFAF9483794@gmail.com', 'M', '34957DF%', 'Nutrição');
exec inserir_dados_medico(4, 'Amanhda Rocha', to_date('10-07-1986','DD-MM-YYYY'), '11983029361', 'amanhda435789@gmail.com', 'F', '8435987DFG', 'Patologia');
exec inserir_dados_medico(5, 'Livia Almeida', to_date('17-01-2000','DD-MM-YYYY'), '11982018451', 'Pink23443@gmail.com', 'F', '54633$dffg', 'Dermatologia');



-------------------  PET  -------------------
create or replace procedure inserir_dados_pet(
ID_pet          IN NUMBER,
ID_hist_FK      IN NUMBER,
NOME_pet        IN VARCHAR2,
ESPECIE_pet     IN VARCHAR2,
RACA_pet        IN VARCHAR2,
DATA_NASC_pet   IN DATE,
PELAGEM_pet     IN VARCHAR2,
PORTE_pet       IN VARCHAR2,
SEXO_pet        IN CHAR,
STATUS_pet      IN VARCHAR2
)
is
    V_MSG_log       VARCHAR2(300);
    V_COD_log       VARCHAR2(50);
    status_exc      EXCEPTION;
    sexo_excedente  EXCEPTION;
    dupl_erro      EXCEPTION;  
    erro_fk           EXCEPTION;

    PRAGMA EXCEPTION_INIT(erro_fk, -2291);
    PRAGMA EXCEPTION_INIT(dupl_erro, -1);
    
begin
    if(not(UPPER(STATUS_pet) = 'ATIVO') and not(UPPER(STATUS_pet) = 'INATIVO')) then
        RAISE status_exc;
        
    elsif(length(SEXO_pet) != 1) then
        RAISE sexo_excedente; 
    end if;
    
    insert into pet_petcore(ID_pet, ID_hist_FK, NOME_pet, ESPECIE_pet, RACA_pet, DATA_NASC_pet, PELAGEM_pet, PORTE_pet, SEXO_pet, STATUS_pet)
        values(ID_pet, ID_hist_FK, NOME_pet, ESPECIE_pet, RACA_pet, DATA_NASC_pet, PELAGEM_pet, PORTE_pet, SEXO_pet, STATUS_pet); 
        
    dbms_output.put_line('Dado inserido na tabela PET com sucesso!');
EXCEPTION
    when erro_fk then
        V_MSG_log := 'ERRO ao adicionar dado na tabela PET. Id do PET ou do TUTOR não foram encontrados';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_pet');

    when dupl_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela PET. Essa entidade já existe';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_pet');

    when status_exc then
        V_MSG_log := 'ERRO ao adicionar dado na tabela PET. "Status" Deve ser "ativo" ou "inativo"';
        V_COD_log := TO_CHAR(SQLCODE);
        
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_pet');

    WHEN sexo_excedente then
        V_MSG_log := 'ERRO ao adicionar dado na tabela PET. "Sexo" deve conter entre 1 caractere';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_pet');
    
    WHEN others then
        V_MSG_log := 'ERRO ao adicionar dado na tabela PET. "Id do historico" não foi encontrado na tabela HISTORICO';  
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_pet');

end;
/


exec inserir_dados_pet(1, 1, 'Olimpio', 'Cachorro', 'Yorkshire', to_date('12-11-2006','DD-MM-YYYY'), 'Média amarronzada', 'Pequeno', 'M','ATIVO');
exec inserir_dados_pet(2, 2, 'Dori', 'Peixe', 'Beta', to_date('10-06-2020','DD-MM-YYYY'), 'Vermelha', 'Pequeno', 'F','ATIVO'); 
exec inserir_dados_pet(3, 3, 'Thor', 'Cachorro', 'Golden retriever', to_date('02-07-2010','DD-MM-YYYY'), 'Amarronzada', 'Medio', 'M','ATIVO'); 
exec inserir_dados_pet(4, 4, 'lidia', 'Gato', 'Malhado', to_date('06-02-2017','DD-MM-YYYY'), 'Malhado', 'Pequeno', 'F','ATIVO'); 
exec inserir_dados_pet(5, 5, 'Maria', 'Cachorro', 'Pug', to_date('19-09-2023','DD-MM-YYYY'), 'Pelagem Preta', 'Pequeno', 'F','ATIVO'); 
exec inserir_dados_pet(6, 6, 'Rico', 'Passaro', 'Papaguaio', to_date('10-10-2007','DD-MM-YYYY'), 'Colorido', 'Pequeno', 'F','ATIVO'); 
exec inserir_dados_pet(7, 7, 'Caramelo', 'Cachorro', 'Vira-lata', to_date('11-12-2021','DD-MM-YYYY'), 'Marrom claro', 'Grande', 'M','ATIVO'); 
exec inserir_dados_pet(8, 8, 'Bebel', 'Cachorro', 'Beagle', to_date('16-03-2019','DD-MM-YYYY'), 'Castanho e Branco', 'Pequeno', 'F','ATIVO'); 
exec inserir_dados_pet(9, 9, 'Moli', 'Cachorro', 'Yorkshire', to_date('03-08-2017','DD-MM-YYYY'), 'Média amarronzada', 'Grande', 'F','ATIVO'); 
exec inserir_dados_pet(10, 10, 'Jully', 'Cachorro', 'Rottweiler', to_date('07-01-2019','DD-MM-YYYY'), 'Preto', 'Media', 'F','ATIVO');


-------------------  TUTOR_PET -> associativa  -------------------
create or replace procedure inserir_dados_tut_pet(
ID_pet_FK       IN NUMBER,
ID_tut_FK       IN NUMBER
)
is
    V_MSG_log       VARCHAR2(300);
    V_COD_log       VARCHAR2(50);
    erro_fk        EXCEPTION;
    dupl_erro      EXCEPTION;
    
    PRAGMA EXCEPTION_INIT(dupl_erro, -1);
    PRAGMA EXCEPTION_INIT(erro_fk, -2291);
    

    
begin
    insert into tut_pet_petcore(ID_pet_FK, ID_tut_FK) values(ID_pet_FK, ID_tut_FK);
    dbms_output.put_line('Dado inserido na tabela TUTOR_PET com sucesso!');

EXCEPTION
    when erro_fk then
        V_MSG_log := 'ERRO ao adicionar dado na tabela TUTOR_PET. Id do PET ou do TUTOR não foram encontrados';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_tut_pet');

    when dupl_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela TUTOR_PET. Esse relacionamento já existe';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_tut_pet');

    when others then
        V_MSG_log := 'ERRO ao adicionar dado na tabela TUTOR_PET. Confira os dados novamente';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_tut_pet');
end;
/


exec inserir_dados_tut_pet(1, 1);
exec inserir_dados_tut_pet(2, 2);
exec inserir_dados_tut_pet(3, 2);
exec inserir_dados_tut_pet(4, 2);
exec inserir_dados_tut_pet(5, 3);
exec inserir_dados_tut_pet(6, 4);
exec inserir_dados_tut_pet(7, 4);
exec inserir_dados_tut_pet(8, 5);
exec inserir_dados_tut_pet(9, 5);
exec inserir_dados_tut_pet(10, 5);



-------------------  RELATORIO  -------------------
create or replace procedure inserir_dados_relatorio(
ID_rel          IN NUMBER,
ID_HIS_FK       IN NUMBER,
ID_MED_FK       IN NUMBER,
OBS_rel         IN VARCHAR2 DEFAULT NULL                                  
)
is
    V_MSG_log       VARCHAR2(300);
    V_COD_log       VARCHAR2(50);
    obs_erro        EXCEPTION;
    fk_erro         EXCEPTION;
    dupl_erro       EXCEPTION;
    
    PRAGMA EXCEPTION_INIT(dupl_erro, -1);
    
    PRAGMA EXCEPTION_INIT(fk_erro, -2291);
    
begin
    if(length(OBS_rel) <= 2 or length(OBS_rel) > 500) then
        RAISE obs_erro;
    end if;

    insert into relatorio_petcore(ID_rel, ID_HIS_FK, ID_MED_FK, OBS_rel) values(ID_rel, ID_HIS_FK, ID_MED_FK, OBS_rel);
    dbms_output.put_line('Dado inserido na tabela RELATORIO com sucesso!');
EXCEPTION
    when fk_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela RELATORIO. Id do HISTORICO ou do MEDICO não foram encontrados';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
    
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_relatorio');
    
    
    when obs_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela RELATORIO. "Observação" deve conter entre 2 à 500 caracteres';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);

        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_relatorio');


    when dupl_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela RELATORIO. Essa entidade já existe';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_relatorio');

    when others then
        V_MSG_log := 'ERRO ao adicionar dado na tabela RELATORIO. Confira os dados novamente';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_relatorio');  
end;
/

exec inserir_dados_relatorio(1, 1, 1, 'exemplo');
exec inserir_dados_relatorio(2, 2, 4, 'Doença do carrapato');
exec inserir_dados_relatorio(3, 3, 3);
exec inserir_dados_relatorio(4, 4, 3);
exec inserir_dados_relatorio(5, 5, 1);
exec inserir_dados_relatorio(6, 6, 3);
exec inserir_dados_relatorio(7, 7, 1, 'Diabete Tipo 2');
exec inserir_dados_relatorio(8, 8, 5);
exec inserir_dados_relatorio(9, 9, 2);
exec inserir_dados_relatorio(10, 10, 1);



-------------------  ENDERECO  -------------------
create or replace procedure inserir_dados_endereco(
ID_end          IN NUMBER,
CEP_end         IN CHAR,
COMPL_end       VARCHAR2 DEFAULT NULL
)
is
    compl_erro        EXCEPTION;
    cep_erro          EXCEPTION;
    V_MSG_log         VARCHAR2(300);
    V_COD_log         VARCHAR2(50);
    dupl_erro         EXCEPTION;
    
    PRAGMA EXCEPTION_INIT(dupl_erro, -1);
begin
    if(length(CEP_end) != 8) then
        RAISE cep_erro;
    elsif(COMPL_end IS NOT NULL AND (length(COMPL_end) <= 2 or length(COMPL_end) > 200)) then
        RAISE compl_erro;
    end if;

    insert into endereco_petcore(ID_end, CEP_end, COMPL_end) values(ID_end, CEP_end, COMPL_end);
    dbms_output.put_line('Dado inserido na tabela ENDERECO com sucesso!');
    
EXCEPTION
    when dupl_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela ENDERECO. Essa entidade já existe';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);

        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_endereco');

    
    when compl_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela ENDERECO. "Complemento" deve conter entre 2 à 200 caracteres';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
     
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_endereco');
   
        
    when cep_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela ENDERECO. "Cep" deve conter entre 8 caracteres';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_endereco');


    when others then
        V_MSG_log := 'ERRO ao adicionar dado na tabela ENDERECO. Confira os dados novamente';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_endereco');  
end;
/

exec inserir_dados_endereco(1, '01001000');
exec inserir_dados_endereco(2, '05999999');
exec inserir_dados_endereco(3, '08000000');
exec inserir_dados_endereco(4, '08499999');
exec inserir_dados_endereco(5, '02000000');
exec inserir_dados_endereco(6, '05999999');



-------------------  CLINICA  -------------------
create or replace procedure inserir_dados_clinica(
ID_cli          IN NUMBER,
ID_ENDER_FK     IN NUMBER,
CNPJ_cli        IN CHAR,
NOME_cli        IN VARCHAR2
)
is
    V_MSG_log         VARCHAR2(300);
    V_COD_log         VARCHAR2(50);
    dupl_erro         EXCEPTION;
    cnpj_erro         EXCEPTION;
    fk_erro           EXCEPTION;
    
    PRAGMA EXCEPTION_INIT(dupl_erro, -1);
    PRAGMA EXCEPTION_INIT(fk_erro, -2291);
begin
    if(length(CNPJ_cli) != 14) then
        RAISE cnpj_erro;
    end if;

    insert into clinica_petcore(ID_cli, ID_ENDER_FK, CNPJ_cli, NOME_cli) values(ID_cli, ID_ENDER_FK, CNPJ_cli, NOME_cli);
    dbms_output.put_line('Dado inserido na tabela CLINICA com sucesso!');  

EXCEPTION
    when fk_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela CLINICA. Id do ENDERECO não foi encontrado';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_clinica');


    when dupl_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela CLINICA. Essa entidade já existe';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_clinica');
    
    when cnpj_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela CLINICA. "Cnpj" Deve conter 14 caracteres';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_clinica');
        
    when others then
        V_MSG_log := 'ERRO ao adicionar dado na tabela CLINICA. Confira os dados novamente';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_clinica');  

end;
/


exec inserir_dados_clinica(1, 1, '49582746381934', 'Clinica Patas');
exec inserir_dados_clinica(2, 2, '34897297593745', 'Clinica ABV');
exec inserir_dados_clinica(3, 3, '91840725034884', 'Clinica PetPte');
exec inserir_dados_clinica(4, 4, '02980141093540', 'Clinica Anjos');
exec inserir_dados_clinica(5, 5, '02934169840254', 'Amorpets');



-------------------  RELATORIO_CLINICA  -------------------
create or replace procedure inserir_dados_rel_cli(
ID_rel_FK          IN NUMBER,
ID_cli_FK          IN NUMBER
)
is
    V_MSG_log         VARCHAR2(300);
    V_COD_log         VARCHAR2(50);
    dupl_erro         EXCEPTION;
    fk_erro           EXCEPTION;
    
    PRAGMA EXCEPTION_INIT(dupl_erro, -1);
    PRAGMA EXCEPTION_INIT(fk_erro, -2291);
begin
    insert into rel_cli_petcore(ID_rel_FK, ID_cli_FK) values(ID_rel_FK, ID_cli_FK);
    dbms_output.put_line('Dado inserido na tabela RELATORIO_CLINICA com sucesso!');  

EXCEPTION
    when fk_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela RELATORIO_CLINICA. Id do RELATORIO ou CLINICA não foram encontrados';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_rel_cli');

    
    when dupl_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela RELATORIO_CLINICA. Essa entidade já existe';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_rel_cli');

    when others then
        V_MSG_log := 'ERRO ao adicionar dado na tabela RELATORIO_CLINICA. Confira os dados novamente';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_rel_cli');  
end;
/


exec inserir_dados_rel_cli(1, 1);
exec inserir_dados_rel_cli(2, 2);
exec inserir_dados_rel_cli(3, 3);
exec inserir_dados_rel_cli(4, 4);
exec inserir_dados_rel_cli(5, 5);



-------------------  EXAME  -------------------
create or replace procedure inserir_dados_exame(
ID_ex           IN NUMBER,
ID_MED_FK       IN NUMBER,
NOME_ex         IN VARCHAR2,
DATA_ex         IN DATE,
TP_ex           IN VARCHAR2
)
is
    V_MSG_log         VARCHAR2(300);
    V_COD_log         VARCHAR2(50);
    dupl_erro         EXCEPTION;
    fk_erro           EXCEPTION;
    
    PRAGMA EXCEPTION_INIT(dupl_erro, -1);
    PRAGMA EXCEPTION_INIT(fk_erro, -2291);
begin
    insert into exame_petcore(ID_ex, ID_MED_FK, NOME_ex, DATA_ex, TP_ex) values(ID_ex, ID_MED_FK, NOME_ex, DATA_ex, TP_ex);
    dbms_output.put_line('Dado inserido na tabela EXAME com sucesso!');      

EXCEPTION
    when fk_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela EXAME. Id do MEDICO não foi encontrado';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_exame');


    when dupl_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela EXAME. Essa entidade já existe';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_exame');
    
    when others then
        V_MSG_log := 'ERRO ao adicionar dado na tabela EXAME. Confira os dados novamente';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_exame'); 
end;
/



exec inserir_dados_exame(1, 1, 'Teste de Glicemia', to_date('07-01-2025','DD-MM-YYYY'), 'Exame endócrino');
exec inserir_dados_exame(2, 2, 'Hemograma completo', to_date('04-05-2025','DD-MM-YYYY'), 'Exame de sangue');
exec inserir_dados_exame(3, 3, 'Exame Raio-x', to_date('02-06-2025','DD-MM-YYYY'), 'Exame de imagem');
exec inserir_dados_exame(4, 4, 'Teste de Glicemia', to_date('17-03-2025','DD-MM-YYYY'), 'Exame endócrino');
exec inserir_dados_exame(5, 5, 'Exame de urina', to_date('27-04-2025','DD-MM-YYYY'), 'Exame parasitológico');
exec inserir_dados_exame(6, 2, 'Hemograma completo', to_date('18-09-2025','DD-MM-YYYY'), 'Exame de sangue');
exec inserir_dados_exame(7, 3, 'Ultrassom abdominal', to_date('13-02-2025','DD-MM-YYYY'), 'Exame de imagem');
exec inserir_dados_exame(8, 1, 'Teste de Glicemia', to_date('10-09-2025','DD-MM-YYYY'), 'Exame endócrino');
exec inserir_dados_exame(9, 4, 'Exame de Raio-x', to_date('20-11-2025','DD-MM-YYYY'), 'Exame de imagem');
exec inserir_dados_exame(10, 5, 'Exame de fezes', to_date('17-05-2025','DD-MM-YYYY'), 'Exame parasitológico');


-------------------  RECEITA  -------------------
create or replace procedure inserir_dados_receita(
ID_rec         IN NUMBER,
ID_MED_FK      IN NUMBER, 
NOME_rec       IN VARCHAR2,
VAL_rec        IN DATE 
)
is
    V_MSG_log         VARCHAR2(300);
    V_COD_log         VARCHAR2(50);
    dupl_erro         EXCEPTION;
    fk_erro           EXCEPTION;
    
    PRAGMA EXCEPTION_INIT(dupl_erro, -1);
    PRAGMA EXCEPTION_INIT(fk_erro, -2291);
begin
    insert into receita_petcore(ID_rec, ID_MED_FK, NOME_rec, VAL_rec) values(ID_rec, ID_MED_FK, NOME_rec, VAL_rec);
    dbms_output.put_line('Dado inserido na tabela RECEITA com sucesso!');      

EXCEPTION
    when fk_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela RECEITA. Id do MEDICO não foi encontrado';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_receita');


    when dupl_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela RECEITA. Essa entidade já existe';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_receita');
        
    when others then
        V_MSG_log := 'ERRO ao adicionar dado na tabela RECEITA. Confira os dados novamente';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_receita'); 
end;
/

exec inserir_dados_receita(1, 1, 'Receita para controle hormonal', to_date('04-02-2026','DD-MM-YYYY'));
exec inserir_dados_receita(2, 2, 'Receita para vermes', to_date('08-01-2026','DD-MM-YYYY'));
exec inserir_dados_receita(3, 3, 'Receita para gripe', to_date('02-01-2026','DD-MM-YYYY'));
exec inserir_dados_receita(4, 4, 'Receita para ', to_date('14-04-2026','DD-MM-YYYY'));
exec inserir_dados_receita(5, 5, 'Receita para controle hormonal', to_date('24-03-2026','DD-MM-YYYY'));
exec inserir_dados_receita(6, 1, 'Receita para controle hormonal', to_date('25-01-2026','DD-MM-YYYY'));
exec inserir_dados_receita(7, 2, 'Receita para controle hormonal', to_date('17-04-2026','DD-MM-YYYY'));
exec inserir_dados_receita(8, 3, 'Receita para controle hormonal', to_date('09-03-2026','DD-MM-YYYY'));
exec inserir_dados_receita(9, 4, 'Receita para controle hormonal', to_date('12-02-2026','DD-MM-YYYY'));
exec inserir_dados_receita(10, 5, 'Receita para controle hormonal', to_date('10-05-2026','DD-MM-YYYY'));

-------------------  MEDICAMENTO  -------------------
create or replace procedure inserir_dados_medics(
ID_medic       IN NUMBER,
NOME_medic     IN VARCHAR2,
DOSAGEM_medic  IN VARCHAR2,
INSTRC_medic   IN VARCHAR2    
)
is
    V_MSG_log         VARCHAR2(300);
    V_COD_log         VARCHAR2(50);
    dupl_erro         EXCEPTION;
    dosg_erro         EXCEPTION;
    
    PRAGMA EXCEPTION_INIT(dupl_erro, -1);
begin
    if(length(DOSAGEM_medic) <= 2 or length(DOSAGEM_medic) > 15) then
        RAISE dosg_erro;
    end if;

    insert into medicamento_petcore(ID_medic, NOME_medic, DOSAGEM_medic, INSTRC_medic) values(ID_medic, NOME_medic, DOSAGEM_medic, INSTRC_medic);
    dbms_output.put_line('Dado inserido na tabela MEDICAMENTO com sucesso!');      

EXCEPTION
    when dupl_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela MEDICAMENTO. Essa entidade já existe';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_medics');
    
    when dosg_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela MEDICAMENTO. "Dosagem" deve conter entre 2 à 15 caracteres';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
     
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_medics');
    
    when others then
        V_MSG_log := 'ERRO ao adicionar dado na tabela MEDICAMENTO. Confira os dados novamente';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_medics'); 
end;
/

exec inserir_dados_medics(1, 'Beneflora', '14mg', '1 Comprimido pela manhã');
exec inserir_dados_medics(2, 'Levotiroxina', '25mg', '1 Comprimido pela manhã');
exec inserir_dados_medics(3, 'Prediderm', '25mg', '1 Comprimido pela manhã e pela noite');
exec inserir_dados_medics(4, 'Vermífugo Fenzol', '500mg', '1 Comprimido pela manhã');
exec inserir_dados_medics(5, 'Levotiroxina', '25mg', '1 Comprimido pela manhã e pela noite');
exec inserir_dados_medics(6, 'Prediderm', '5mg', '1 Comprimido pela manhã');
exec inserir_dados_medics(7, 'Levotiroxina', '50mg', '1 Comprimido pela manhã');
exec inserir_dados_medics(8, 'Beneflora', '14mg', '1 Comprimido pela manhã');
exec inserir_dados_medics(9, 'Vermífugo Fenzol', '500mg', '1 Comprimido pela manhãe pela noite');
exec inserir_dados_medics(10, 'Levotiroxina', '25mg', '1 Comprimido pela manhã');

-------------------  RECEITA_MEDICAMENTO  -------------------
create or replace procedure inserir_dados_rec_medic(
ID_rec_FK      IN NUMBER,
ID_medic_FK    IN NUMBER
)
is
    V_MSG_log       VARCHAR2(300);
    V_COD_log       VARCHAR2(50);
    erro_fk         EXCEPTION;
    dupl_erro       EXCEPTION;
    
    PRAGMA EXCEPTION_INIT(dupl_erro, -1);
    PRAGMA EXCEPTION_INIT(erro_fk, -2291);
    

    
begin
    insert into rec_medic_petcore(ID_rec_FK, ID_medic_FK) values(ID_rec_FK, ID_medic_FK);
    dbms_output.put_line('Dado inserido na tabela RECEITA_MEDICAMENTO com sucesso!');

EXCEPTION
    when erro_fk then
        V_MSG_log := 'ERRO ao adicionar dado na tabela RECEITA_MEDICAMENTO. Id da RECEITA ou do MEDICAMENTO não foram encontrados';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_rec_medic');

    when dupl_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela RECEITA_MEDICAMENTO. Esse relacionamento já existe';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_rec_medic');

    when others then
        V_MSG_log := 'ERRO ao adicionar dado na tabela RECEITA_MEDICAMENTO. Confira os dados novamente';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_rec_medic');
end;
/

exec inserir_dados_rec_medic(1, 1);
exec inserir_dados_rec_medic(2, 2);
exec inserir_dados_rec_medic(3, 2);
exec inserir_dados_rec_medic(4, 4);
exec inserir_dados_rec_medic(5, 5);
exec inserir_dados_rec_medic(6, 6);
exec inserir_dados_rec_medic(7, 5);
exec inserir_dados_rec_medic(8, 8);
exec inserir_dados_rec_medic(9, 2);
exec inserir_dados_rec_medic(10, 3);

-------------------  PRONTUARIO  -------------------
create or replace procedure inserir_dados_prontuario(
ID_pront       IN NUMBER,
ID_HIST_FK     IN NUMBER,
ID_MED_FK      IN NUMBER,
DATA_pront     IN DATE,
DESC_pront     IN VARCHAR2
)
is
    V_MSG_log       VARCHAR2(300);
    V_COD_log       VARCHAR2(50);
    erro_fk         EXCEPTION;
    dupl_erro       EXCEPTION;
    
    PRAGMA EXCEPTION_INIT(dupl_erro, -1);
    PRAGMA EXCEPTION_INIT(erro_fk, -2291);
     
begin
    insert into prontuario_petcore(ID_pront, ID_HIST_FK, ID_MED_FK, DATA_pront, DESC_pront) values(ID_pront, ID_HIST_FK, ID_MED_FK, DATA_pront, DESC_pront);
    dbms_output.put_line('Dado inserido na tabela PRONTUARIO com sucesso!');

EXCEPTION
    when erro_fk then
        V_MSG_log := 'ERRO ao adicionar dado na tabela PRONTUARIO. Id do HISTORICO ou do MEDICO não foram encontrados';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_prontuario');

    when dupl_erro then
        V_MSG_log := 'ERRO ao adicionar dado na tabela PRONTUARIO. Essa entidade já existe';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_prontuario');

    when others then
        V_MSG_log := 'ERRO ao adicionar dado na tabela PRONTUARIO. Confira os dados novamente';
        V_COD_log := TO_CHAR(SQLCODE);
        dbms_output.put_line(V_MSG_log);
        
        insert into log_petcore(NOME_log, DATA_log, COD_log, MSG_log, NOME_PROC_log) values(USER, SYSDATE, V_COD_log, V_MSG_log, 'inserir_dados_prontuario');
end;
/

exec inserir_dados_prontuario(1, 1, 1, to_date('08-05-2026','DD-MM-YYYY'), 'Paciente apresentou alteração hormonal. Tratamento iniciado.');
exec inserir_dados_prontuario(2, 2, 2, to_date('07-01-2026','DD-MM-YYYY'), 'Paciente apresentou melhora do tratamento de hipotermia.');
exec inserir_dados_prontuario(3, 3, 3, to_date('03-05-2026','DD-MM-YYYY'), 'Paciente apresentou febre alta e fadiga. Tratamento iniciado.');
exec inserir_dados_prontuario(4, 4, 4, to_date('13-02-2026','DD-MM-YYYY'), 'Paciente apresentou sintamosa de diabetes. Tratamento iniciado.');
exec inserir_dados_prontuario(5, 5, 5, to_date('09-03-2026','DD-MM-YYYY'), 'Paciente apresentou alteração hormonal. Tratamento iniciado.');
exec inserir_dados_prontuario(6, 6, 1, to_date('02-05-2026','DD-MM-YYYY'), 'Paciente apresentou sintomas da doença do carrapato. Tratamento iniciado.');
exec inserir_dados_prontuario(7, 7, 3, to_date('22-04-2026','DD-MM-YYYY'), 'Paciente apresentou melhora no tratamento da diarreia.');
-- ==================================================================
/*
SELECT 
    tut.id_tut "Id tutor",
    tut.nome_tut "Nome tutor",
    pet.id_pet "Id pet",
    pet.nome_pet "Nome pet"
FROM tutor_petcore tut
INNER JOIN tut_pet_petcore tut_pet 
    ON tut_pet.id_tut_fk = tut.id_tut
INNER JOIN pet_petcore pet 
    ON pet.id_pet = tut_pet.id_pet_fk
order by tut.id_tut;

-----------------------------
SELECT 
    especie_pet,
    COUNT(*) "Quantidade"
FROM pet_petcore
GROUP BY especie_pet;
-----------------------------
SELECT
    hist.id_hist "Id historico",
    hist.data_hist "Data historico",
    hist.status_hist "Status historico",
    pront.id_pront "Id prontuário",
    med.nome_med "Nome medico responsável"
from historico_petcore hist
inner join prontuario_petcore pront on pront.id_hist_fk = hist.id_hist
inner join medico_petcore med on med.id_med = pront.id_med_fk;

-- id do tutor, nome do tutor -> tut_pet -> id do pet, nome do pet
*/

















