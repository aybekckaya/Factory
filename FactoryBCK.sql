PGDMP         4                x            Factory    12.3    12.3 [    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16472    Factory    DATABASE     g   CREATE DATABASE "Factory" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C';
    DROP DATABASE "Factory";
                postgres    false            �            1255    16639 0   add_address(integer, integer, character varying) 	   PROCEDURE     �   CREATE PROCEDURE public.add_address(sehir_id integer, ilce_id integer, text character varying)
    LANGUAGE plpgsql
    AS $$ BEGIN
   insert into public.adres(text,sehir_id,ilce_id) values(text,sehir_id,ilce_id);
 END;$$;
 ^   DROP PROCEDURE public.add_address(sehir_id integer, ilce_id integer, text character varying);
       public          postgres    false            �            1255    16640 C   add_factory(character varying, integer, integer, character varying) 	   PROCEDURE     �  CREATE PROCEDURE public.add_factory(factory_name character varying, city_id integer, ilce_id integer, address_text character varying)
    LANGUAGE plpgsql
    AS $$DECLARE 
  tempMax INTEGER;
 BEGIN 
   insert into public.adres(text,sehir_id,ilce_id) values(address_text,city_id,ilce_id);
   SELECT id Into tempMax FROM public.adres ORDER BY id DESC LIMIT 1;
   insert into public.fabrika(fabrika_adi,adres_id) values(factory_name,tempMax);

 END;$$;
 �   DROP PROCEDURE public.add_factory(factory_name character varying, city_id integer, ilce_id integer, address_text character varying);
       public          postgres    false            �            1255    16649 !   add_imalathane(character varying) 	   PROCEDURE     �   CREATE PROCEDURE public.add_imalathane(imalathane_adi character varying)
    LANGUAGE plpgsql
    AS $$ BEGIN 
  insert into public.imalathane(imalathane_adi) values(imalathane_adi);
END;$$;
 H   DROP PROCEDURE public.add_imalathane(imalathane_adi character varying);
       public          postgres    false            �            1255    16661    log_table()    FUNCTION     �   CREATE FUNCTION public.log_table() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN
   insert into logtable select 'ALTER Table',now();
 END;$$;
 "   DROP FUNCTION public.log_table();
       public          postgres    false            �            1255    16650    remove_factory(integer) 	   PROCEDURE     6  CREATE PROCEDURE public.remove_factory(factory_id integer)
    LANGUAGE plpgsql
    AS $$ BEGIN
   delete from public.fabrika WHERE id = factory_id;
   delete from public.fabrika_imalathane WHERE fabrika_id = factory_id;
   update public.genel_mudur SET fabrika_id = -1 WHERE fabrika_id = factory_id;
 END;$$;
 :   DROP PROCEDURE public.remove_factory(factory_id integer);
       public          postgres    false            �            1255    16652    remove_imalathane(integer) 	   PROCEDURE     �  CREATE PROCEDURE public.remove_imalathane(im_id integer)
    LANGUAGE plpgsql
    AS $$BEGIN
   delete from public.imalathane where id = im_id;
   delete from public.imalathane_urun where imalathane_id = im_id;
   update public.personel set imalathane_id=-1 where imalathane_id = im_id;
   update public.sorumlu set imalathane_id=-1 where imalathane_id = im_id;
   delete from public.fabrika_imalathane where imalathane_id = im_id;
 END;$$;
 8   DROP PROCEDURE public.remove_imalathane(im_id integer);
       public          postgres    false            �            1255    16653    remove_kategori(integer) 	   PROCEDURE     �   CREATE PROCEDURE public.remove_kategori(cat_id integer)
    LANGUAGE plpgsql
    AS $$ BEGIN
  delete from public.kategori where id = cat_id;
  update public.urun set kategori_id = -1 where kategori_id = cat_id;
 END;$$;
 7   DROP PROCEDURE public.remove_kategori(cat_id integer);
       public          postgres    false            �            1255    16663    trigger_scream()    FUNCTION     L  CREATE FUNCTION public.trigger_scream() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN
      IF (TG_OP = 'DELETE') THEN
	    RAISE NOTICE 'DELETED: ';
      ELSIF (TG_OP = 'UPDATE') THEN
	    RAISE NOTICE 'UPDATED: ';
      ELSIF (TG_OP = 'INSERT') THEN
	    RAISE NOTICE 'INSERTED: ';
      END IF;
    RETURN NULL;
	END;$$;
 '   DROP FUNCTION public.trigger_scream();
       public          postgres    false            �            1259    16518    adres    TABLE     �   CREATE TABLE public.adres (
    id integer NOT NULL,
    text character varying(220),
    sehir_id integer,
    ilce_id integer
);
    DROP TABLE public.adres;
       public         heap    postgres    false            �            1259    16610    adres_id_seq    SEQUENCE     �   ALTER TABLE public.adres ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.adres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);
            public          postgres    false    210            �            1259    16503    fabrika    TABLE     �   CREATE TABLE public.fabrika (
    id integer NOT NULL,
    fabrika_adi character varying(120) NOT NULL,
    adres_id integer
);
    DROP TABLE public.fabrika;
       public         heap    postgres    false            �            1259    16616    fabrika_id_seq    SEQUENCE     �   ALTER TABLE public.fabrika ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.fabrika_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);
            public          postgres    false    207            �            1259    16508    fabrika_imalathane    TABLE     w   CREATE TABLE public.fabrika_imalathane (
    id integer NOT NULL,
    fabrika_id integer,
    imalathane_id integer
);
 &   DROP TABLE public.fabrika_imalathane;
       public         heap    postgres    false            �            1259    16665    fabrika_imalathane_id_seq    SEQUENCE     �   ALTER TABLE public.fabrika_imalathane ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.fabrika_imalathane_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);
            public          postgres    false    208            �            1259    16483    kisi    TABLE     �   CREATE TABLE public.kisi (
    id integer NOT NULL,
    ad character varying(34) NOT NULL,
    soyad character varying(34) NOT NULL,
    iletisim_id integer
);
    DROP TABLE public.kisi;
       public         heap    postgres    false            �            1259    16543    genel_mudur    TABLE     \   CREATE TABLE public.genel_mudur (
    fabrika_id integer NOT NULL
)
INHERITS (public.kisi);
    DROP TABLE public.genel_mudur;
       public         heap    postgres    false    203            �            1259    16641    genel_mudur_id_seq    SEQUENCE     �   ALTER TABLE public.genel_mudur ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.genel_mudur_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);
            public          postgres    false    215            �            1259    16523    ilce    TABLE     Z   CREATE TABLE public.ilce (
    id integer NOT NULL,
    ilce_adi character varying(56)
);
    DROP TABLE public.ilce;
       public         heap    postgres    false            �            1259    16614    ilce_id_seq    SEQUENCE     �   ALTER TABLE public.ilce ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ilce_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);
            public          postgres    false    211            �            1259    16478    iletisim    TABLE     r   CREATE TABLE public.iletisim (
    id integer NOT NULL,
    tel_no character varying(24),
    adres_id integer
);
    DROP TABLE public.iletisim;
       public         heap    postgres    false            �            1259    16528 
   imalathane    TABLE     f   CREATE TABLE public.imalathane (
    id integer NOT NULL,
    imalathane_adi character varying(64)
);
    DROP TABLE public.imalathane;
       public         heap    postgres    false            �            1259    16618    imalathane_id_seq    SEQUENCE     �   ALTER TABLE public.imalathane ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.imalathane_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);
            public          postgres    false    212            �            1259    16538    imalathane_urun    TABLE     q   CREATE TABLE public.imalathane_urun (
    id integer NOT NULL,
    imalathane_id integer,
    urun_id integer
);
 #   DROP TABLE public.imalathane_urun;
       public         heap    postgres    false            �            1259    16628    imalathane_urun_id_seq    SEQUENCE     �   ALTER TABLE public.imalathane_urun ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.imalathane_urun_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);
            public          postgres    false    214            �            1259    16546    kategori    TABLE     c   CREATE TABLE public.kategori (
    id integer NOT NULL,
    kategori_adi character varying(120)
);
    DROP TABLE public.kategori;
       public         heap    postgres    false            �            1259    16620    kategori_id_seq    SEQUENCE     �   ALTER TABLE public.kategori ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.kategori_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);
            public          postgres    false    216            �            1259    16622    kisi_id_seq    SEQUENCE     �   ALTER TABLE public.kisi ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.kisi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);
            public          postgres    false    203            �            1259    16654    logtable    TABLE     �   CREATE TABLE public.logtable (
    id integer NOT NULL,
    log_text character varying(120),
    time_log timestamp(6) with time zone
);
    DROP TABLE public.logtable;
       public         heap    postgres    false            �            1259    16659    logtable_id_seq    SEQUENCE     �   ALTER TABLE public.logtable ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.logtable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);
            public          postgres    false    230            �            1259    16500    personel    TABLE     u   CREATE TABLE public.personel (
    imalathane_id integer,
    gorev character varying(120)
)
INHERITS (public.kisi);
    DROP TABLE public.personel;
       public         heap    postgres    false    203            �            1259    16643    personel_id_seq    SEQUENCE     �   ALTER TABLE public.personel ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.personel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);
            public          postgres    false    206            �            1259    16494    personel_yakini    TABLE     X   CREATE TABLE public.personel_yakini (
    personel_id integer
)
INHERITS (public.kisi);
 #   DROP TABLE public.personel_yakini;
       public         heap    postgres    false    203            �            1259    16645    personel_yakini_id_seq    SEQUENCE     �   ALTER TABLE public.personel_yakini ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.personel_yakini_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);
            public          postgres    false    204            �            1259    16513    sehir    TABLE     \   CREATE TABLE public.sehir (
    id integer NOT NULL,
    sehir_adi character varying(45)
);
    DROP TABLE public.sehir;
       public         heap    postgres    false            �            1259    16612    sehir_id_seq    SEQUENCE     �   ALTER TABLE public.sehir ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sehir_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);
            public          postgres    false    209            �            1259    16497    sorumlu    TABLE     i   CREATE TABLE public.sorumlu (
    ulasim_id integer,
    imalathane_id integer
)
INHERITS (public.kisi);
    DROP TABLE public.sorumlu;
       public         heap    postgres    false    203            �            1259    16647    sorumlu_id_seq    SEQUENCE     �   ALTER TABLE public.sorumlu ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sorumlu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);
            public          postgres    false    205            �            1259    16533    urun    TABLE     t   CREATE TABLE public.urun (
    id integer NOT NULL,
    urun_adi character varying(120),
    kategori_id integer
);
    DROP TABLE public.urun;
       public         heap    postgres    false            �            1259    16624    urun_id_seq    SEQUENCE     �   ALTER TABLE public.urun ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.urun_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 500
    CACHE 1
);
            public          postgres    false    213            �          0    16518    adres 
   TABLE DATA           <   COPY public.adres (id, text, sehir_id, ilce_id) FROM stdin;
    public          postgres    false    210   �f       �          0    16503    fabrika 
   TABLE DATA           <   COPY public.fabrika (id, fabrika_adi, adres_id) FROM stdin;
    public          postgres    false    207   �g       �          0    16508    fabrika_imalathane 
   TABLE DATA           K   COPY public.fabrika_imalathane (id, fabrika_id, imalathane_id) FROM stdin;
    public          postgres    false    208   gh       �          0    16543    genel_mudur 
   TABLE DATA           M   COPY public.genel_mudur (id, ad, soyad, iletisim_id, fabrika_id) FROM stdin;
    public          postgres    false    215   �h       �          0    16523    ilce 
   TABLE DATA           ,   COPY public.ilce (id, ilce_adi) FROM stdin;
    public          postgres    false    211   5i       �          0    16478    iletisim 
   TABLE DATA           8   COPY public.iletisim (id, tel_no, adres_id) FROM stdin;
    public          postgres    false    202   bi       �          0    16528 
   imalathane 
   TABLE DATA           8   COPY public.imalathane (id, imalathane_adi) FROM stdin;
    public          postgres    false    212   �i       �          0    16538    imalathane_urun 
   TABLE DATA           E   COPY public.imalathane_urun (id, imalathane_id, urun_id) FROM stdin;
    public          postgres    false    214   �i       �          0    16546    kategori 
   TABLE DATA           4   COPY public.kategori (id, kategori_adi) FROM stdin;
    public          postgres    false    216   j       �          0    16483    kisi 
   TABLE DATA           :   COPY public.kisi (id, ad, soyad, iletisim_id) FROM stdin;
    public          postgres    false    203   Nj       �          0    16654    logtable 
   TABLE DATA           :   COPY public.logtable (id, log_text, time_log) FROM stdin;
    public          postgres    false    230   kj       �          0    16500    personel 
   TABLE DATA           T   COPY public.personel (id, ad, soyad, iletisim_id, imalathane_id, gorev) FROM stdin;
    public          postgres    false    206   �j       �          0    16494    personel_yakini 
   TABLE DATA           R   COPY public.personel_yakini (id, ad, soyad, iletisim_id, personel_id) FROM stdin;
    public          postgres    false    204   �j       �          0    16513    sehir 
   TABLE DATA           .   COPY public.sehir (id, sehir_adi) FROM stdin;
    public          postgres    false    209   �j       �          0    16497    sorumlu 
   TABLE DATA           W   COPY public.sorumlu (id, ad, soyad, iletisim_id, ulasim_id, imalathane_id) FROM stdin;
    public          postgres    false    205   �j       �          0    16533    urun 
   TABLE DATA           9   COPY public.urun (id, urun_adi, kategori_id) FROM stdin;
    public          postgres    false    213   k       �           0    0    adres_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.adres_id_seq', 23, true);
          public          postgres    false    217            �           0    0    fabrika_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.fabrika_id_seq', 14, true);
          public          postgres    false    220            �           0    0    fabrika_imalathane_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.fabrika_imalathane_id_seq', 10, true);
          public          postgres    false    232            �           0    0    genel_mudur_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.genel_mudur_id_seq', 6, true);
          public          postgres    false    226            �           0    0    ilce_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.ilce_id_seq', 2, true);
          public          postgres    false    219            �           0    0    imalathane_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.imalathane_id_seq', 12, true);
          public          postgres    false    221            �           0    0    imalathane_urun_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.imalathane_urun_id_seq', 2, true);
          public          postgres    false    225            �           0    0    kategori_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.kategori_id_seq', 8, true);
          public          postgres    false    222            �           0    0    kisi_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.kisi_id_seq', 1, false);
          public          postgres    false    223            �           0    0    logtable_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.logtable_id_seq', 1, false);
          public          postgres    false    231            �           0    0    personel_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.personel_id_seq', 1, false);
          public          postgres    false    227            �           0    0    personel_yakini_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.personel_yakini_id_seq', 1, false);
          public          postgres    false    228            �           0    0    sehir_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sehir_id_seq', 2, true);
          public          postgres    false    218            �           0    0    sorumlu_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.sorumlu_id_seq', 1, false);
          public          postgres    false    229            �           0    0    urun_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.urun_id_seq', 5, true);
          public          postgres    false    224            ,           2606    16522    adres adres_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.adres
    ADD CONSTRAINT adres_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.adres DROP CONSTRAINT adres_pkey;
       public            postgres    false    210            (           2606    16512 *   fabrika_imalathane fabrika_imalathane_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.fabrika_imalathane
    ADD CONSTRAINT fabrika_imalathane_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.fabrika_imalathane DROP CONSTRAINT fabrika_imalathane_pkey;
       public            postgres    false    208            &           2606    16507    fabrika fabrika_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.fabrika
    ADD CONSTRAINT fabrika_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.fabrika DROP CONSTRAINT fabrika_pkey;
       public            postgres    false    207            .           2606    16527    ilce ilce_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.ilce
    ADD CONSTRAINT ilce_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.ilce DROP CONSTRAINT ilce_pkey;
       public            postgres    false    211                       2606    16482    iletisim iletisim_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.iletisim
    ADD CONSTRAINT iletisim_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.iletisim DROP CONSTRAINT iletisim_pkey;
       public            postgres    false    202            0           2606    16532    imalathane imalathane_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.imalathane
    ADD CONSTRAINT imalathane_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.imalathane DROP CONSTRAINT imalathane_pkey;
       public            postgres    false    212            4           2606    16542 $   imalathane_urun imalathane_urun_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.imalathane_urun
    ADD CONSTRAINT imalathane_urun_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.imalathane_urun DROP CONSTRAINT imalathane_urun_pkey;
       public            postgres    false    214            6           2606    16550    kategori kategori_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.kategori
    ADD CONSTRAINT kategori_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.kategori DROP CONSTRAINT kategori_pkey;
       public            postgres    false    216            "           2606    16487    kisi kisi_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.kisi
    ADD CONSTRAINT kisi_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.kisi DROP CONSTRAINT kisi_pkey;
       public            postgres    false    203            8           2606    16658    logtable logtable_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.logtable
    ADD CONSTRAINT logtable_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.logtable DROP CONSTRAINT logtable_pkey;
       public            postgres    false    230            *           2606    16517    sehir sehir_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.sehir
    ADD CONSTRAINT sehir_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.sehir DROP CONSTRAINT sehir_pkey;
       public            postgres    false    209            $           2606    16627    sorumlu sorumlu_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.sorumlu
    ADD CONSTRAINT sorumlu_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.sorumlu DROP CONSTRAINT sorumlu_pkey;
       public            postgres    false    205            2           2606    16537    urun urun_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.urun
    ADD CONSTRAINT urun_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.urun DROP CONSTRAINT urun_pkey;
       public            postgres    false    213                        1259    16493    fki_iletisim_id    INDEX     G   CREATE INDEX fki_iletisim_id ON public.kisi USING btree (iletisim_id);
 #   DROP INDEX public.fki_iletisim_id;
       public            postgres    false    203            ;           2620    16662    kategori kategori_log_trigger    TRIGGER     �   CREATE TRIGGER kategori_log_trigger AFTER INSERT OR UPDATE OF id, kategori_adi ON public.kategori FOR EACH STATEMENT EXECUTE FUNCTION public.log_table();
 6   DROP TRIGGER kategori_log_trigger ON public.kategori;
       public          postgres    false    216    239    216    216            :           2620    16664    urun scream_alterations    TRIGGER     �   CREATE TRIGGER scream_alterations AFTER INSERT OR UPDATE ON public.urun FOR EACH STATEMENT EXECUTE FUNCTION public.trigger_scream();
 0   DROP TRIGGER scream_alterations ON public.urun;
       public          postgres    false    213    240            9           2606    16488    kisi iletisim_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.kisi
    ADD CONSTRAINT iletisim_id FOREIGN KEY (iletisim_id) REFERENCES public.iletisim(id) NOT VALID;
 :   ALTER TABLE ONLY public.kisi DROP CONSTRAINT iletisim_id;
       public          postgres    false    202    203    3103            �   �   x�}��N1�g�)�
)j��w�L,Lep�����(��>c�>C��½\�@9C���g��0RDp�����u��%��N�����q����l��5^cY�&}�-v��a풾�����}��sJ�3�=>p�K�9k���^�����'��<o}l,"6��"��j�p���c�0|� ���4r�����[��/ɿ��h�_6�<�0y����23#!{���R_\}n�      �   a   x�3�<�<5;�(=��Ќ��g�eh���������id�eh��X���SpKL*��N,>���Ș˔S�M��Є��N�91O�;�2��Д+F��� W� e      �   .   x���  �w�{�B�u��}jBi�e�V�Q+9�o�/      �   �   x�3��/�M���ٜ����\ƜN�EG6��雘wxy>P�Ӕ˄�Ȇ��\��Ҥģ�l��q�re&'��s�&����s�qޓ�Z	2:85	,j�e��)M���N�+	����� ��)g      �      x�3��M�M��2�,)��I����� A�i      �      x�3�40242266b�?.#t�=... ���      �   X   x�3�<���$1/�4G�Ȇ�ĜĒ�ļ��L.sNǼ�ĢD4aΐҪtQK���#�s�lTp?�1(Q���Ј�=5�*&����� ��0�      �      x������ � �      �   (   x�3�)��)Up?�1%1'��˜3$�$��F�H� 1*      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   !   x�3��,.I�K*��2�L��N,J����� e�      �      x������ � �      �   <   x�3�J�,�̫L<2��FN]C.CN�����ĒDτ�5;75�Ә˔3��ӄ+F��� �     