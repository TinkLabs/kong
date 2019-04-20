--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.12
-- Dumped by pg_dump version 11.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: delete_expired_cluster_events(); Type: FUNCTION; Schema: public; Owner: hipayadmin
--

CREATE FUNCTION public.delete_expired_cluster_events() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
          DELETE FROM "cluster_events"
                WHERE "expire_at" <= CURRENT_TIMESTAMP AT TIME ZONE 'UTC';
          RETURN NEW;
        END;
      $$;


ALTER FUNCTION public.delete_expired_cluster_events() OWNER TO hipayadmin;

--
-- Name: sync_tags(); Type: FUNCTION; Schema: public; Owner: hipayadmin
--

CREATE FUNCTION public.sync_tags() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
          IF (TG_OP = 'TRUNCATE') THEN
            DELETE FROM tags WHERE entity_name = TG_TABLE_NAME;
            RETURN NULL;
          ELSIF (TG_OP = 'DELETE') THEN
            DELETE FROM tags WHERE entity_id = OLD.id;
            RETURN OLD;
          ELSE

          -- Triggered by INSERT/UPDATE
          -- Do an upsert on the tags table
          -- So we don't need to migrate pre 1.1 entities
          INSERT INTO tags VALUES (NEW.id, TG_TABLE_NAME, NEW.tags)
          ON CONFLICT (entity_id) DO UPDATE
                  SET tags=EXCLUDED.tags;
          END IF;
          RETURN NEW;
        END;
      $$;


ALTER FUNCTION public.sync_tags() OWNER TO hipayadmin;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: acls; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.acls (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    "group" text,
    cache_key text
);


ALTER TABLE public.acls OWNER TO hipayadmin;

--
-- Name: apis; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.apis (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(3) with time zone),
    name text,
    upstream_url text,
    preserve_host boolean NOT NULL,
    retries smallint DEFAULT 5,
    https_only boolean,
    http_if_terminated boolean,
    hosts text,
    uris text,
    methods text,
    strip_uri boolean,
    upstream_connect_timeout integer,
    upstream_send_timeout integer,
    upstream_read_timeout integer
);


ALTER TABLE public.apis OWNER TO hipayadmin;

--
-- Name: basicauth_credentials; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.basicauth_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    username text,
    password text
);


ALTER TABLE public.basicauth_credentials OWNER TO hipayadmin;

--
-- Name: certificates; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.certificates (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    cert text,
    key text,
    tags text[]
);


ALTER TABLE public.certificates OWNER TO hipayadmin;

--
-- Name: cluster_ca; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.cluster_ca (
    pk boolean NOT NULL,
    key text NOT NULL,
    cert text NOT NULL,
    CONSTRAINT cluster_ca_pk_check CHECK ((pk = true))
);


ALTER TABLE public.cluster_ca OWNER TO hipayadmin;

--
-- Name: cluster_events; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.cluster_events (
    id uuid NOT NULL,
    node_id uuid NOT NULL,
    at timestamp with time zone NOT NULL,
    nbf timestamp with time zone,
    expire_at timestamp with time zone NOT NULL,
    channel text,
    data text
);


ALTER TABLE public.cluster_events OWNER TO hipayadmin;

--
-- Name: consumers; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.consumers (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    username text,
    custom_id text,
    tags text[]
);


ALTER TABLE public.consumers OWNER TO hipayadmin;

--
-- Name: hmacauth_credentials; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.hmacauth_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    username text,
    secret text
);


ALTER TABLE public.hmacauth_credentials OWNER TO hipayadmin;

--
-- Name: jwt_secrets; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.jwt_secrets (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    key text,
    secret text,
    algorithm text,
    rsa_public_key text
);


ALTER TABLE public.jwt_secrets OWNER TO hipayadmin;

--
-- Name: keyauth_credentials; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.keyauth_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    key text
);


ALTER TABLE public.keyauth_credentials OWNER TO hipayadmin;

--
-- Name: locks; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.locks (
    key text NOT NULL,
    owner text,
    ttl timestamp with time zone
);


ALTER TABLE public.locks OWNER TO hipayadmin;

--
-- Name: oauth2_authorization_codes; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.oauth2_authorization_codes (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    credential_id uuid,
    service_id uuid,
    code text,
    authenticated_userid text,
    scope text,
    ttl timestamp with time zone
);


ALTER TABLE public.oauth2_authorization_codes OWNER TO hipayadmin;

--
-- Name: oauth2_credentials; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.oauth2_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    name text,
    consumer_id uuid,
    client_id text,
    client_secret text,
    redirect_uris text[]
);


ALTER TABLE public.oauth2_credentials OWNER TO hipayadmin;

--
-- Name: oauth2_tokens; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.oauth2_tokens (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    credential_id uuid,
    service_id uuid,
    access_token text,
    refresh_token text,
    token_type text,
    expires_in integer,
    authenticated_userid text,
    scope text,
    ttl timestamp with time zone
);


ALTER TABLE public.oauth2_tokens OWNER TO hipayadmin;

--
-- Name: plugins; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.plugins (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    name text NOT NULL,
    consumer_id uuid,
    service_id uuid,
    route_id uuid,
    api_id uuid,
    config jsonb NOT NULL,
    enabled boolean NOT NULL,
    cache_key text,
    run_on text,
    protocols text[],
    tags text[]
);


ALTER TABLE public.plugins OWNER TO hipayadmin;

--
-- Name: ratelimiting_metrics; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.ratelimiting_metrics (
    identifier text NOT NULL,
    period text NOT NULL,
    period_date timestamp with time zone NOT NULL,
    service_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    route_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    value integer
);


ALTER TABLE public.ratelimiting_metrics OWNER TO hipayadmin;

--
-- Name: response_ratelimiting_metrics; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.response_ratelimiting_metrics (
    identifier text NOT NULL,
    period text NOT NULL,
    period_date timestamp with time zone NOT NULL,
    service_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    route_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    value integer
);


ALTER TABLE public.response_ratelimiting_metrics OWNER TO hipayadmin;

--
-- Name: routes; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.routes (
    id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    service_id uuid,
    protocols text[],
    methods text[],
    hosts text[],
    paths text[],
    regex_priority bigint,
    strip_path boolean,
    preserve_host boolean,
    name text,
    snis text[],
    sources jsonb[],
    destinations jsonb[],
    tags text[]
);


ALTER TABLE public.routes OWNER TO hipayadmin;

--
-- Name: schema_meta; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.schema_meta (
    key text NOT NULL,
    subsystem text NOT NULL,
    last_executed text,
    executed text[],
    pending text[]
);


ALTER TABLE public.schema_meta OWNER TO hipayadmin;

--
-- Name: services; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.services (
    id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name text,
    retries bigint,
    protocol text,
    host text,
    port bigint,
    path text,
    connect_timeout bigint,
    write_timeout bigint,
    read_timeout bigint,
    tags text[]
);


ALTER TABLE public.services OWNER TO hipayadmin;

--
-- Name: snis; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.snis (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    name text NOT NULL,
    certificate_id uuid,
    tags text[]
);


ALTER TABLE public.snis OWNER TO hipayadmin;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.tags (
    entity_id uuid NOT NULL,
    entity_name text,
    tags text[]
);


ALTER TABLE public.tags OWNER TO hipayadmin;

--
-- Name: targets; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.targets (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(3) with time zone),
    upstream_id uuid,
    target text NOT NULL,
    weight integer NOT NULL,
    tags text[]
);


ALTER TABLE public.targets OWNER TO hipayadmin;

--
-- Name: ttls; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.ttls (
    primary_key_value text NOT NULL,
    primary_uuid_value uuid,
    table_name text NOT NULL,
    primary_key_name text NOT NULL,
    expire_at timestamp without time zone NOT NULL
);


ALTER TABLE public.ttls OWNER TO hipayadmin;

--
-- Name: upstreams; Type: TABLE; Schema: public; Owner: hipayadmin
--

CREATE TABLE public.upstreams (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(3) with time zone),
    name text,
    hash_on text,
    hash_fallback text,
    hash_on_header text,
    hash_fallback_header text,
    hash_on_cookie text,
    hash_on_cookie_path text,
    slots integer NOT NULL,
    healthchecks jsonb,
    tags text[]
);


ALTER TABLE public.upstreams OWNER TO hipayadmin;

--
-- Data for Name: acls; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.acls (id, created_at, consumer_id, "group", cache_key) FROM stdin;
\.


--
-- Data for Name: apis; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.apis (id, created_at, name, upstream_url, preserve_host, retries, https_only, http_if_terminated, hosts, uris, methods, strip_uri, upstream_connect_timeout, upstream_send_timeout, upstream_read_timeout) FROM stdin;
\.


--
-- Data for Name: basicauth_credentials; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.basicauth_credentials (id, created_at, consumer_id, username, password) FROM stdin;
\.


--
-- Data for Name: certificates; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.certificates (id, created_at, cert, key, tags) FROM stdin;
\.


--
-- Data for Name: cluster_ca; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.cluster_ca (pk, key, cert) FROM stdin;
t	-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDdiBiC70ClG5k4\nxRwrgRaCxlENIWckPelaQLjsBgE+/OY06XZPuN5VAGpluSyJNaq2PYLRv8sR2jfb\ny1XJ3EH6HKRvv4mdHuX1L/fZD5sfhCnivDqknn5Xdz6kJ/m5+q0F0aUSVcrLU/CN\n6rNDF/P6H5PG0XIULfLXbKcYfwRhJylJGObHi0ToenH60r27m6wQEEKT0gZ1QYrw\nGbPmHTIjtTpfPsoprLzXQYnd63Hb8477QvinIQ/+zLqzAy+m+XKLlFnepInXyOOX\nRvFBLX5K0Gtw+gsRe3Gf6k8GeqF/TlfbtDeoa6P7Ivq00Bd54W6n2cHJ6byEdi1q\nPGnEWBEzAgMBAAECggEBAJjuylUhzBPvgJBzauYRoLO5Kt0QsT6Qyxa2VbMC1jtg\npZ/jh/yzWDGALvN4qWkztl1HC5e3ev4hEqzWq6vGNXnv6gkHRn5EhWYFrmmX33Qb\nbjsLzMQ2cmv5czIqMrkUd/vrZbTJq01A7nFalFR+Jb0HraH0l3ec3OehJ52+mgxi\njiCMzHWwKOd5ppGVeZloVeooqsuZhMRHB/OM3SQLixZIqkRi+ujq0sLfK4w/40w6\n1I6Y3n93ZZ5/iEH/j5rFk5ieR4L0JpGAvDfWM1wnfSQ1x7bds7kdAwUzTxQ0WlRG\nLVLsqdz2dhX0HCUuyOjVzgfn6P8toi/QqjTu+As4W7kCgYEA/d0ngsQT9rM8i6im\nKnCQ9bQoVnHDavARThR7+Vjtd8a4qGXoDe5xpysTdwkVxTjBEhI9IXlI7G++OUdI\neDRDrnGigO2eXat2nLOrc7gA6TB1aVX5o+xo1IzWYYG3EcLaDYjL30yVn7aRScsG\nRBbRK2bkM5eXsh5fRCbyyiIKge0CgYEA32VLeKcC0dcBOC83eOdAeGilLUxuOE7l\n2hr3xvXzyGh/Pw50TdZ9yACaSt/zaVYrao1cbfL7Moxfrm9+QP6g1uQ9/x3xHt9S\nMZC0a31Jbr8u5uWEQuphXB8N/w0GhOiAY97jogm7U3cXXOzIM4YynvFqKERPdsmL\n/7v+7wZm+58CgYEA7oZB3nrvKwfjpnEyl4OmoEXC9N31N+AS0mMqzPECRl0gGZGO\nhLB6dxBhPKH7o5Ac0Cb06yOzIfwoJldUvySURy6b+jnJZ8d4Leoe+R51NKUEXJGc\neqnhIXym3XzsjrKfAMJ8k/W4TBVU05n/7C/oHriRR+xyarhg2H8j9kofx00CgYEA\n2dmIPcJwR33qHIY/DFJHVqSF36TXH2YhVA5UbtvOvjLZU/6egIGY639a94Vpc+Gq\nOSBdcIMxX9vwOsVTU8J7ytONecoTJ04Uc21v5Bqrj6o07MoJrs+t3g4SshRbtSSe\nf8YOKihfW0eZqu7lVQmbN9Co+1eSPn7RXbRRKXsO1nUCgYAHsSVUnply/KGcn0Rw\nZNgStGh1GUS57LlTIk9rmGFVL5CjGvnIQa9hc0WlYqo/R2Ai9cuGLV8pmpjBTZdP\nJ1lrphOv2OzaT9YCQfivY4ZVkFg5kku4J3acWh3yCjn+/PKO2plE7JPhOiCWDKRX\nq9SKtRf4R+P0RRasbPn+tgIkZw==\n-----END PRIVATE KEY-----\n	-----BEGIN CERTIFICATE-----\nMIIDZTCCAk2gAwIBAgIQfmDv1MFCviAYsYRye6haAjANBgkqhkiG9w0BAQsFADA8\nMTowOAYDVQQDDDFrb25nLWNsdXN0ZXItMWQyY2ZiOTgtYmIwZi00MmUwLThkOWIt\nNjI4MTdkZGMxY2FmMB4XDTE5MDQxNTA2MzIyMVoXDTM5MDQxMDA2MzIyMVowPDE6\nMDgGA1UEAwwxa29uZy1jbHVzdGVyLTFkMmNmYjk4LWJiMGYtNDJlMC04ZDliLTYy\nODE3ZGRjMWNhZjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN2IGILv\nQKUbmTjFHCuBFoLGUQ0hZyQ96VpAuOwGAT785jTpdk+43lUAamW5LIk1qrY9gtG/\nyxHaN9vLVcncQfocpG+/iZ0e5fUv99kPmx+EKeK8OqSefld3PqQn+bn6rQXRpRJV\nystT8I3qs0MX8/ofk8bRchQt8tdspxh/BGEnKUkY5seLROh6cfrSvbubrBAQQpPS\nBnVBivAZs+YdMiO1Ol8+yimsvNdBid3rcdvzjvtC+KchD/7MurMDL6b5couUWd6k\nidfI45dG8UEtfkrQa3D6CxF7cZ/qTwZ6oX9OV9u0N6hro/si+rTQF3nhbqfZwcnp\nvIR2LWo8acRYETMCAwEAAaNjMGEwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8E\nBAMCAQYwHQYDVR0OBBYEFEqOqKpnXzjqTcTyvtWW7MEFqxWlMB8GA1UdIwQYMBaA\nFEqOqKpnXzjqTcTyvtWW7MEFqxWlMA0GCSqGSIb3DQEBCwUAA4IBAQAVInAwy7QM\nzU0HNMfgJntCDZdJ8j15s0+7UvwTDo9m9ACg+e89Z2mdNMa0xUsz0lj4qxSDcEOu\n56A6v7YRwxDp2UauXGIIlKhFJZTQn3eBgrqaI6X8sLiebLbdwAxDK7ANAVPbFS0L\nd6HswNeVv2IZzhjNNGeNyC+F+zr4U/zEYS/EEJj7GidopJ91QnYBOolUbRnLiDzO\nA7IIzBKw2M4NDqGcis5RfvbYCbHHpUU2Ume2pn2GW9epyN2xRF6NsQjEwfz8pMtk\nklBVtZrX4rcI1fQyWVT6ARw3d2NoHbcSs1i8X6jrRduTvcYSi8rh0wFAtHxTF8tn\nYuX7HAehl5Au\n-----END CERTIFICATE-----\n
\.


--
-- Data for Name: cluster_events; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) FROM stdin;
09365553-5266-4f20-baf9-2a05d7a6cd3f	f99b1dbb-9f4e-4bd0-aa13-78bec1baefb3	2019-04-18 07:41:48.611+00	\N	2019-04-18 08:41:48.611+00	invalidations	routes:0c8f9960-cc82-4243-a5a8-abe6a73107af::::
6cc64e5a-2a65-428b-b11c-53e175a97630	f99b1dbb-9f4e-4bd0-aa13-78bec1baefb3	2019-04-18 07:41:48.613+00	\N	2019-04-18 08:41:48.613+00	invalidations	routes:0c8f9960-cc82-4243-a5a8-abe6a73107af::::
6bdd7490-09dc-481d-aada-fce74910b163	f99b1dbb-9f4e-4bd0-aa13-78bec1baefb3	2019-04-18 07:41:48.614+00	\N	2019-04-18 08:41:48.614+00	invalidations	router:version
01617b18-9404-41ae-80ce-c169a6dc5447	f99b1dbb-9f4e-4bd0-aa13-78bec1baefb3	2019-04-18 07:42:07.697+00	\N	2019-04-18 08:42:07.697+00	invalidations	routes:0c8f9960-cc82-4243-a5a8-abe6a73107af::::
adf29e40-90e9-4b6b-8427-350bd28ee82e	f99b1dbb-9f4e-4bd0-aa13-78bec1baefb3	2019-04-18 07:42:07.698+00	\N	2019-04-18 08:42:07.698+00	invalidations	routes:0c8f9960-cc82-4243-a5a8-abe6a73107af::::
ea0429be-3963-4f20-8e83-d26ef613de31	f99b1dbb-9f4e-4bd0-aa13-78bec1baefb3	2019-04-18 07:42:07.7+00	\N	2019-04-18 08:42:07.7+00	invalidations	router:version
e51b0b0b-987d-46df-9dd6-83edde898287	f99b1dbb-9f4e-4bd0-aa13-78bec1baefb3	2019-04-18 07:42:15.328+00	\N	2019-04-18 08:42:15.328+00	invalidations	routes:0c8f9960-cc82-4243-a5a8-abe6a73107af::::
d7fbec2c-e445-41c2-8ade-73236c7ad853	f99b1dbb-9f4e-4bd0-aa13-78bec1baefb3	2019-04-18 07:42:15.329+00	\N	2019-04-18 08:42:15.329+00	invalidations	routes:0c8f9960-cc82-4243-a5a8-abe6a73107af::::
643a43a4-cf23-4c2a-9688-6b1cafc84915	f99b1dbb-9f4e-4bd0-aa13-78bec1baefb3	2019-04-18 07:42:15.329+00	\N	2019-04-18 08:42:15.329+00	invalidations	router:version
\.


--
-- Data for Name: consumers; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.consumers (id, created_at, username, custom_id, tags) FROM stdin;
\.


--
-- Data for Name: hmacauth_credentials; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.hmacauth_credentials (id, created_at, consumer_id, username, secret) FROM stdin;
\.


--
-- Data for Name: jwt_secrets; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.jwt_secrets (id, created_at, consumer_id, key, secret, algorithm, rsa_public_key) FROM stdin;
\.


--
-- Data for Name: keyauth_credentials; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.keyauth_credentials (id, created_at, consumer_id, key) FROM stdin;
\.


--
-- Data for Name: locks; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.locks (key, owner, ttl) FROM stdin;
\.


--
-- Data for Name: oauth2_authorization_codes; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.oauth2_authorization_codes (id, created_at, credential_id, service_id, code, authenticated_userid, scope, ttl) FROM stdin;
\.


--
-- Data for Name: oauth2_credentials; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.oauth2_credentials (id, created_at, name, consumer_id, client_id, client_secret, redirect_uris) FROM stdin;
\.


--
-- Data for Name: oauth2_tokens; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.oauth2_tokens (id, created_at, credential_id, service_id, access_token, refresh_token, token_type, expires_in, authenticated_userid, scope, ttl) FROM stdin;
\.


--
-- Data for Name: plugins; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.plugins (id, created_at, name, consumer_id, service_id, route_id, api_id, config, enabled, cache_key, run_on, protocols, tags) FROM stdin;
0a1b70d8-c71c-44a4-99b7-ab3b67a0470a	2019-04-16 11:55:48+00	cors	\N	\N	\N	\N	{"headers": ["Content-Type", "Accept", "Date", "Content-Length", "X-Api-Key", "X-Payment-Request-ID", "X-Refund-Request-ID", "X-Request-Id", "Accept-Version"], "max_age": 86400, "methods": ["GET", "POST", "PATCH"], "origins": ["*"], "credentials": true, "exposed_headers": ["payment_id", "refund_id"], "preflight_continue": false}	t	plugins:cors::::	first	{http,https}	\N
\.


--
-- Data for Name: ratelimiting_metrics; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.ratelimiting_metrics (identifier, period, period_date, service_id, route_id, value) FROM stdin;
\.


--
-- Data for Name: response_ratelimiting_metrics; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.response_ratelimiting_metrics (identifier, period, period_date, service_id, route_id, value) FROM stdin;
\.


--
-- Data for Name: routes; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.routes (id, created_at, updated_at, service_id, protocols, methods, hosts, paths, regex_priority, strip_path, preserve_host, name, snis, sources, destinations, tags) FROM stdin;
c4a57d38-4984-4db7-92e3-589904cc190d	2019-04-17 04:10:52+00	2019-04-17 04:17:44+00	adddea66-54d3-46dd-b86c-31ab8678b514	{http,https}	{GET,POST,PATCH}	{localhost}	{/payments}	0	f	t	v0_payments	\N	\N	\N	\N
b8570cab-f76a-41c0-ace0-c9a6d21c189f	2019-04-17 04:09:11+00	2019-04-17 04:18:25+00	adddea66-54d3-46dd-b86c-31ab8678b514	{http,https}	{GET}	{localhost}	{/config}	0	f	t	v0_config	\N	\N	\N	\N
71cb8392-85ce-44ea-b529-f6fe37ddd4f8	2019-04-17 04:14:03+00	2019-04-17 04:18:40+00	adddea66-54d3-46dd-b86c-31ab8678b514	{http,https}	{GET}	{localhost}	{/refunds}	0	f	t	v0_refunds	\N	\N	\N	\N
fc30f246-f427-41b0-af77-8a0df5b0f489	2019-04-16 12:09:57+00	2019-04-17 04:07:23+00	adddea66-54d3-46dd-b86c-31ab8678b514	{http,https}	{GET,POST,PATCH}	{localhost}	{/v1/refunds}	0	f	t	v1_refunds	\N	\N	\N	\N
4b8e8fe6-6e7b-4953-9068-a11edba2219c	2019-04-16 12:09:34+00	2019-04-17 04:07:38+00	adddea66-54d3-46dd-b86c-31ab8678b514	{http,https}	{GET,POST,PATCH}	{localhost}	{/v1/payments}	0	f	t	v1_payments	\N	\N	\N	\N
b26dca1f-9e4c-49a9-8eb1-a85a49f558a4	2019-04-16 07:31:31+00	2019-04-17 04:07:53+00	adddea66-54d3-46dd-b86c-31ab8678b514	{http,https}	{GET,POST,PATCH}	{localhost}	{/v1/applications}	0	f	t	v1_applications	\N	\N	\N	\N
0c8f9960-cc82-4243-a5a8-abe6a73107af	2019-04-17 04:19:55+00	2019-04-18 07:42:15+00	adddea66-54d3-46dd-b86c-31ab8678b514	{http,https}	{GET,POST,PATCH}	{localhost}	{/applications}	0	f	t	v0_applications	\N	\N	\N	\N
\.


--
-- Data for Name: schema_meta; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.schema_meta (key, subsystem, last_executed, executed, pending) FROM stdin;
schema_meta	core	003_100_to_110	{000_base,001_14_to_15,002_15_to_1,003_100_to_110}	{}
schema_meta	oauth2	002_15_to_10	{000_base_oauth2,001_14_to_15,002_15_to_10}	{}
schema_meta	acl	001_14_to_15	{000_base_acl,001_14_to_15}	{}
schema_meta	jwt	001_14_to_15	{000_base_jwt,001_14_to_15}	\N
schema_meta	basic-auth	001_14_to_15	{000_base_basic_auth,001_14_to_15}	\N
schema_meta	key-auth	001_14_to_15	{000_base_key_auth,001_14_to_15}	\N
schema_meta	rate-limiting	002_15_to_10	{000_base_rate_limiting,001_14_to_15,002_15_to_10}	{}
schema_meta	hmac-auth	001_14_to_15	{000_base_hmac_auth,001_14_to_15}	\N
schema_meta	response-ratelimiting	002_15_to_10	{000_base_response_rate_limiting,001_14_to_15,002_15_to_10}	{}
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.services (id, created_at, updated_at, name, retries, protocol, host, port, path, connect_timeout, write_timeout, read_timeout, tags) FROM stdin;
adddea66-54d3-46dd-b86c-31ab8678b514	2019-04-16 07:28:47+00	2019-04-17 04:07:10+00	upstream_8080	5	http	10.0.10.190	8080	/	60000	60000	60000	{}
\.


--
-- Data for Name: snis; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.snis (id, created_at, name, certificate_id, tags) FROM stdin;
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.tags (entity_id, entity_name, tags) FROM stdin;
adddea66-54d3-46dd-b86c-31ab8678b514	services	{}
fc30f246-f427-41b0-af77-8a0df5b0f489	routes	\N
4b8e8fe6-6e7b-4953-9068-a11edba2219c	routes	\N
b26dca1f-9e4c-49a9-8eb1-a85a49f558a4	routes	\N
0a1b70d8-c71c-44a4-99b7-ab3b67a0470a	plugins	\N
c4a57d38-4984-4db7-92e3-589904cc190d	routes	\N
b8570cab-f76a-41c0-ace0-c9a6d21c189f	routes	\N
71cb8392-85ce-44ea-b529-f6fe37ddd4f8	routes	\N
0c8f9960-cc82-4243-a5a8-abe6a73107af	routes	\N
\.


--
-- Data for Name: targets; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.targets (id, created_at, upstream_id, target, weight, tags) FROM stdin;
\.


--
-- Data for Name: ttls; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.ttls (primary_key_value, primary_uuid_value, table_name, primary_key_name, expire_at) FROM stdin;
\.


--
-- Data for Name: upstreams; Type: TABLE DATA; Schema: public; Owner: hipayadmin
--

COPY public.upstreams (id, created_at, name, hash_on, hash_fallback, hash_on_header, hash_fallback_header, hash_on_cookie, hash_on_cookie_path, slots, healthchecks, tags) FROM stdin;
\.


--
-- Name: acls acls_cache_key_key; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_cache_key_key UNIQUE (cache_key);


--
-- Name: acls acls_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_pkey PRIMARY KEY (id);


--
-- Name: apis apis_name_key; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.apis
    ADD CONSTRAINT apis_name_key UNIQUE (name);


--
-- Name: apis apis_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.apis
    ADD CONSTRAINT apis_pkey PRIMARY KEY (id);


--
-- Name: basicauth_credentials basicauth_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_pkey PRIMARY KEY (id);


--
-- Name: basicauth_credentials basicauth_credentials_username_key; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_username_key UNIQUE (username);


--
-- Name: certificates certificates_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_pkey PRIMARY KEY (id);


--
-- Name: cluster_ca cluster_ca_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.cluster_ca
    ADD CONSTRAINT cluster_ca_pkey PRIMARY KEY (pk);


--
-- Name: cluster_events cluster_events_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.cluster_events
    ADD CONSTRAINT cluster_events_pkey PRIMARY KEY (id);


--
-- Name: consumers consumers_custom_id_key; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_custom_id_key UNIQUE (custom_id);


--
-- Name: consumers consumers_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_pkey PRIMARY KEY (id);


--
-- Name: consumers consumers_username_key; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_username_key UNIQUE (username);


--
-- Name: hmacauth_credentials hmacauth_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_pkey PRIMARY KEY (id);


--
-- Name: hmacauth_credentials hmacauth_credentials_username_key; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_username_key UNIQUE (username);


--
-- Name: jwt_secrets jwt_secrets_key_key; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_key_key UNIQUE (key);


--
-- Name: jwt_secrets jwt_secrets_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_pkey PRIMARY KEY (id);


--
-- Name: keyauth_credentials keyauth_credentials_key_key; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_key_key UNIQUE (key);


--
-- Name: keyauth_credentials keyauth_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_pkey PRIMARY KEY (id);


--
-- Name: locks locks_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.locks
    ADD CONSTRAINT locks_pkey PRIMARY KEY (key);


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_code_key; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_code_key UNIQUE (code);


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_pkey PRIMARY KEY (id);


--
-- Name: oauth2_credentials oauth2_credentials_client_id_key; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_client_id_key UNIQUE (client_id);


--
-- Name: oauth2_credentials oauth2_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_pkey PRIMARY KEY (id);


--
-- Name: oauth2_tokens oauth2_tokens_access_token_key; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_access_token_key UNIQUE (access_token);


--
-- Name: oauth2_tokens oauth2_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_pkey PRIMARY KEY (id);


--
-- Name: oauth2_tokens oauth2_tokens_refresh_token_key; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_refresh_token_key UNIQUE (refresh_token);


--
-- Name: plugins plugins_cache_key_key; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_cache_key_key UNIQUE (cache_key);


--
-- Name: plugins plugins_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_pkey PRIMARY KEY (id);


--
-- Name: ratelimiting_metrics ratelimiting_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.ratelimiting_metrics
    ADD CONSTRAINT ratelimiting_metrics_pkey PRIMARY KEY (identifier, period, period_date, service_id, route_id);


--
-- Name: response_ratelimiting_metrics response_ratelimiting_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.response_ratelimiting_metrics
    ADD CONSTRAINT response_ratelimiting_metrics_pkey PRIMARY KEY (identifier, period, period_date, service_id, route_id);


--
-- Name: routes routes_name_key; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_name_key UNIQUE (name);


--
-- Name: routes routes_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (id);


--
-- Name: schema_meta schema_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.schema_meta
    ADD CONSTRAINT schema_meta_pkey PRIMARY KEY (key, subsystem);


--
-- Name: services services_name_key; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_name_key UNIQUE (name);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: snis snis_name_key; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_name_key UNIQUE (name);


--
-- Name: snis snis_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (entity_id);


--
-- Name: targets targets_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_pkey PRIMARY KEY (id);


--
-- Name: ttls ttls_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.ttls
    ADD CONSTRAINT ttls_pkey PRIMARY KEY (primary_key_value, table_name);


--
-- Name: upstreams upstreams_name_key; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_name_key UNIQUE (name);


--
-- Name: upstreams upstreams_pkey; Type: CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_pkey PRIMARY KEY (id);


--
-- Name: acls_consumer_id_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX acls_consumer_id_idx ON public.acls USING btree (consumer_id);


--
-- Name: acls_group_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX acls_group_idx ON public.acls USING btree ("group");


--
-- Name: basicauth_consumer_id_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX basicauth_consumer_id_idx ON public.basicauth_credentials USING btree (consumer_id);


--
-- Name: certificates_tags_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX certificates_tags_idx ON public.certificates USING gin (tags);


--
-- Name: cluster_events_at_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX cluster_events_at_idx ON public.cluster_events USING btree (at);


--
-- Name: cluster_events_channel_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX cluster_events_channel_idx ON public.cluster_events USING btree (channel);


--
-- Name: consumers_tags_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX consumers_tags_idx ON public.consumers USING gin (tags);


--
-- Name: consumers_username_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX consumers_username_idx ON public.consumers USING btree (lower(username));


--
-- Name: hmacauth_credentials_consumer_id_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX hmacauth_credentials_consumer_id_idx ON public.hmacauth_credentials USING btree (consumer_id);


--
-- Name: jwt_secrets_consumer_id_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX jwt_secrets_consumer_id_idx ON public.jwt_secrets USING btree (consumer_id);


--
-- Name: jwt_secrets_secret_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX jwt_secrets_secret_idx ON public.jwt_secrets USING btree (secret);


--
-- Name: keyauth_credentials_consumer_id_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX keyauth_credentials_consumer_id_idx ON public.keyauth_credentials USING btree (consumer_id);


--
-- Name: locks_ttl_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX locks_ttl_idx ON public.locks USING btree (ttl);


--
-- Name: oauth2_authorization_codes_authenticated_userid_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX oauth2_authorization_codes_authenticated_userid_idx ON public.oauth2_authorization_codes USING btree (authenticated_userid);


--
-- Name: oauth2_authorization_credential_id_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX oauth2_authorization_credential_id_idx ON public.oauth2_authorization_codes USING btree (credential_id);


--
-- Name: oauth2_authorization_service_id_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX oauth2_authorization_service_id_idx ON public.oauth2_authorization_codes USING btree (service_id);


--
-- Name: oauth2_credentials_consumer_id_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX oauth2_credentials_consumer_id_idx ON public.oauth2_credentials USING btree (consumer_id);


--
-- Name: oauth2_credentials_secret_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX oauth2_credentials_secret_idx ON public.oauth2_credentials USING btree (client_secret);


--
-- Name: oauth2_tokens_authenticated_userid_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX oauth2_tokens_authenticated_userid_idx ON public.oauth2_tokens USING btree (authenticated_userid);


--
-- Name: oauth2_tokens_credential_id_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX oauth2_tokens_credential_id_idx ON public.oauth2_tokens USING btree (credential_id);


--
-- Name: oauth2_tokens_service_id_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX oauth2_tokens_service_id_idx ON public.oauth2_tokens USING btree (service_id);


--
-- Name: plugins_api_id_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX plugins_api_id_idx ON public.plugins USING btree (api_id);


--
-- Name: plugins_consumer_id_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX plugins_consumer_id_idx ON public.plugins USING btree (consumer_id);


--
-- Name: plugins_name_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX plugins_name_idx ON public.plugins USING btree (name);


--
-- Name: plugins_route_id_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX plugins_route_id_idx ON public.plugins USING btree (route_id);


--
-- Name: plugins_run_on_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX plugins_run_on_idx ON public.plugins USING btree (run_on);


--
-- Name: plugins_service_id_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX plugins_service_id_idx ON public.plugins USING btree (service_id);


--
-- Name: plugins_tags_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX plugins_tags_idx ON public.plugins USING gin (tags);


--
-- Name: routes_service_id_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX routes_service_id_idx ON public.routes USING btree (service_id);


--
-- Name: routes_tags_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX routes_tags_idx ON public.routes USING gin (tags);


--
-- Name: services_tags_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX services_tags_idx ON public.services USING gin (tags);


--
-- Name: snis_certificate_id_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX snis_certificate_id_idx ON public.snis USING btree (certificate_id);


--
-- Name: snis_tags_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX snis_tags_idx ON public.snis USING gin (tags);


--
-- Name: tags_entity_name_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX tags_entity_name_idx ON public.tags USING btree (entity_name);


--
-- Name: tags_tags_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX tags_tags_idx ON public.tags USING gin (tags);


--
-- Name: targets_tags_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX targets_tags_idx ON public.targets USING gin (tags);


--
-- Name: targets_target_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX targets_target_idx ON public.targets USING btree (target);


--
-- Name: targets_upstream_id_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX targets_upstream_id_idx ON public.targets USING btree (upstream_id);


--
-- Name: ttls_primary_uuid_value_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX ttls_primary_uuid_value_idx ON public.ttls USING btree (primary_uuid_value);


--
-- Name: upstreams_tags_idx; Type: INDEX; Schema: public; Owner: hipayadmin
--

CREATE INDEX upstreams_tags_idx ON public.upstreams USING gin (tags);


--
-- Name: certificates certificates_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: hipayadmin
--

CREATE TRIGGER certificates_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.certificates FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: consumers consumers_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: hipayadmin
--

CREATE TRIGGER consumers_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.consumers FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: cluster_events delete_expired_cluster_events_trigger; Type: TRIGGER; Schema: public; Owner: hipayadmin
--

CREATE TRIGGER delete_expired_cluster_events_trigger AFTER INSERT ON public.cluster_events FOR EACH STATEMENT EXECUTE PROCEDURE public.delete_expired_cluster_events();


--
-- Name: plugins plugins_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: hipayadmin
--

CREATE TRIGGER plugins_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.plugins FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: routes routes_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: hipayadmin
--

CREATE TRIGGER routes_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.routes FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: services services_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: hipayadmin
--

CREATE TRIGGER services_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.services FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: snis snis_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: hipayadmin
--

CREATE TRIGGER snis_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.snis FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: targets targets_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: hipayadmin
--

CREATE TRIGGER targets_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.targets FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: upstreams upstreams_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: hipayadmin
--

CREATE TRIGGER upstreams_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.upstreams FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: acls acls_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;


--
-- Name: basicauth_credentials basicauth_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;


--
-- Name: hmacauth_credentials hmacauth_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;


--
-- Name: jwt_secrets jwt_secrets_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;


--
-- Name: keyauth_credentials keyauth_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_credential_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_credential_id_fkey FOREIGN KEY (credential_id) REFERENCES public.oauth2_credentials(id) ON DELETE CASCADE;


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: oauth2_credentials oauth2_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;


--
-- Name: oauth2_tokens oauth2_tokens_credential_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_credential_id_fkey FOREIGN KEY (credential_id) REFERENCES public.oauth2_credentials(id) ON DELETE CASCADE;


--
-- Name: oauth2_tokens oauth2_tokens_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: plugins plugins_api_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_api_id_fkey FOREIGN KEY (api_id) REFERENCES public.apis(id) ON DELETE CASCADE;


--
-- Name: plugins plugins_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;


--
-- Name: plugins plugins_route_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_route_id_fkey FOREIGN KEY (route_id) REFERENCES public.routes(id) ON DELETE CASCADE;


--
-- Name: plugins plugins_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: routes routes_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- Name: snis snis_certificate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_certificate_id_fkey FOREIGN KEY (certificate_id) REFERENCES public.certificates(id);


--
-- Name: targets targets_upstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hipayadmin
--

ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_upstream_id_fkey FOREIGN KEY (upstream_id) REFERENCES public.upstreams(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

