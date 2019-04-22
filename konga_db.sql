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

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: konga_api_health_checks; Type: TABLE; Schema: public; owner: hipayadmin
--

CREATE TABLE public.konga_api_health_checks (
    id integer NOT NULL,
    api_id text,
    api json,
    health_check_endpoint text,
    notification_endpoint text,
    active boolean,
    data json,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_api_health_checks OWNER to hipayadmin;

--
-- Name: konga_api_health_checks_id_seq; Type: SEQUENCE; Schema: public; owner: hipayadmin
--

CREATE SEQUENCE public.konga_api_health_checks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_api_health_checks_id_seq OWNER to hipayadmin;

--
-- Name: konga_api_health_checks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; owner: hipayadmin
--

ALTER SEQUENCE public.konga_api_health_checks_id_seq OWNED BY public.konga_api_health_checks.id;


--
-- Name: konga_email_transports; Type: TABLE; Schema: public; owner: hipayadmin
--

CREATE TABLE public.konga_email_transports (
    id integer NOT NULL,
    name text,
    description text,
    schema json,
    settings json,
    active boolean,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_email_transports OWNER to hipayadmin;

--
-- Name: konga_email_transports_id_seq; Type: SEQUENCE; Schema: public; owner: hipayadmin
--

CREATE SEQUENCE public.konga_email_transports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_email_transports_id_seq OWNER to hipayadmin;

--
-- Name: konga_email_transports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; owner: hipayadmin
--

ALTER SEQUENCE public.konga_email_transports_id_seq OWNED BY public.konga_email_transports.id;


--
-- Name: konga_kong_nodes; Type: TABLE; Schema: public; owner: hipayadmin
--

CREATE TABLE public.konga_kong_nodes (
    id integer NOT NULL,
    name text,
    type text,
    kong_admin_url text,
    netdata_url text,
    kong_api_key text,
    jwt_algorithm text,
    jwt_key text,
    jwt_secret text,
    kong_version text,
    health_checks boolean,
    health_check_details json,
    active boolean,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_kong_nodes OWNER to hipayadmin;

--
-- Name: konga_kong_nodes_id_seq; Type: SEQUENCE; Schema: public; owner: hipayadmin
--

CREATE SEQUENCE public.konga_kong_nodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_kong_nodes_id_seq OWNER to hipayadmin;

--
-- Name: konga_kong_nodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; owner: hipayadmin
--

ALTER SEQUENCE public.konga_kong_nodes_id_seq OWNED BY public.konga_kong_nodes.id;


--
-- Name: konga_kong_services; Type: TABLE; Schema: public; owner: hipayadmin
--

CREATE TABLE public.konga_kong_services (
    id integer NOT NULL,
    service_id text,
    kong_node_id text,
    description text,
    tags json,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_kong_services OWNER to hipayadmin;

--
-- Name: konga_kong_services_id_seq; Type: SEQUENCE; Schema: public; owner: hipayadmin
--

CREATE SEQUENCE public.konga_kong_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_kong_services_id_seq OWNER to hipayadmin;

--
-- Name: konga_kong_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; owner: hipayadmin
--

ALTER SEQUENCE public.konga_kong_services_id_seq OWNED BY public.konga_kong_services.id;


--
-- Name: konga_kong_snapshot_schedules; Type: TABLE; Schema: public; owner: hipayadmin
--

CREATE TABLE public.konga_kong_snapshot_schedules (
    id integer NOT NULL,
    connection integer,
    active boolean,
    cron text,
    "lastRunAt" date,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_kong_snapshot_schedules OWNER to hipayadmin;

--
-- Name: konga_kong_snapshot_schedules_id_seq; Type: SEQUENCE; Schema: public; owner: hipayadmin
--

CREATE SEQUENCE public.konga_kong_snapshot_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_kong_snapshot_schedules_id_seq OWNER to hipayadmin;

--
-- Name: konga_kong_snapshot_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; owner: hipayadmin
--

ALTER SEQUENCE public.konga_kong_snapshot_schedules_id_seq OWNED BY public.konga_kong_snapshot_schedules.id;


--
-- Name: konga_kong_snapshots; Type: TABLE; Schema: public; owner: hipayadmin
--

CREATE TABLE public.konga_kong_snapshots (
    id integer NOT NULL,
    name text,
    kong_node_name text,
    kong_node_url text,
    kong_version text,
    data json,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_kong_snapshots OWNER to hipayadmin;

--
-- Name: konga_kong_snapshots_id_seq; Type: SEQUENCE; Schema: public; owner: hipayadmin
--

CREATE SEQUENCE public.konga_kong_snapshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_kong_snapshots_id_seq OWNER to hipayadmin;

--
-- Name: konga_kong_snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; owner: hipayadmin
--

ALTER SEQUENCE public.konga_kong_snapshots_id_seq OWNED BY public.konga_kong_snapshots.id;


--
-- Name: konga_kong_upstream_alerts; Type: TABLE; Schema: public; owner: hipayadmin
--

CREATE TABLE public.konga_kong_upstream_alerts (
    id integer NOT NULL,
    upstream_id text,
    connection integer,
    email boolean,
    slack boolean,
    cron text,
    active boolean,
    data json,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_kong_upstream_alerts OWNER to hipayadmin;

--
-- Name: konga_kong_upstream_alerts_id_seq; Type: SEQUENCE; Schema: public; owner: hipayadmin
--

CREATE SEQUENCE public.konga_kong_upstream_alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_kong_upstream_alerts_id_seq OWNER to hipayadmin;

--
-- Name: konga_kong_upstream_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; owner: hipayadmin
--

ALTER SEQUENCE public.konga_kong_upstream_alerts_id_seq OWNED BY public.konga_kong_upstream_alerts.id;


--
-- Name: konga_netdata_connections; Type: TABLE; Schema: public; owner: hipayadmin
--

CREATE TABLE public.konga_netdata_connections (
    id integer NOT NULL,
    "apiId" text,
    url text,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_netdata_connections OWNER to hipayadmin;

--
-- Name: konga_netdata_connections_id_seq; Type: SEQUENCE; Schema: public; owner: hipayadmin
--

CREATE SEQUENCE public.konga_netdata_connections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_netdata_connections_id_seq OWNER to hipayadmin;

--
-- Name: konga_netdata_connections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; owner: hipayadmin
--

ALTER SEQUENCE public.konga_netdata_connections_id_seq OWNED BY public.konga_netdata_connections.id;


--
-- Name: konga_passports; Type: TABLE; Schema: public; owner: hipayadmin
--

CREATE TABLE public.konga_passports (
    id integer NOT NULL,
    protocol text,
    password text,
    provider text,
    identifier text,
    tokens json,
    "user" integer,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.konga_passports OWNER to hipayadmin;

--
-- Name: konga_passports_id_seq; Type: SEQUENCE; Schema: public; owner: hipayadmin
--

CREATE SEQUENCE public.konga_passports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_passports_id_seq OWNER to hipayadmin;

--
-- Name: konga_passports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; owner: hipayadmin
--

ALTER SEQUENCE public.konga_passports_id_seq OWNED BY public.konga_passports.id;


--
-- Name: konga_settings; Type: TABLE; Schema: public; owner: hipayadmin
--

CREATE TABLE public.konga_settings (
    id integer NOT NULL,
    data json,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_settings OWNER to hipayadmin;

--
-- Name: konga_settings_id_seq; Type: SEQUENCE; Schema: public; owner: hipayadmin
--

CREATE SEQUENCE public.konga_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_settings_id_seq OWNER to hipayadmin;

--
-- Name: konga_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; owner: hipayadmin
--

ALTER SEQUENCE public.konga_settings_id_seq OWNED BY public.konga_settings.id;


--
-- Name: konga_users; Type: TABLE; Schema: public; owner: hipayadmin
--

CREATE TABLE public.konga_users (
    id integer NOT NULL,
    username text,
    email text,
    "firstName" text,
    "lastName" text,
    admin boolean,
    node_id text,
    active boolean,
    "activationToken" text,
    node integer,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_users OWNER to hipayadmin;

--
-- Name: konga_users_id_seq; Type: SEQUENCE; Schema: public; owner: hipayadmin
--

CREATE SEQUENCE public.konga_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_users_id_seq OWNER to hipayadmin;

--
-- Name: konga_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; owner: hipayadmin
--

ALTER SEQUENCE public.konga_users_id_seq OWNED BY public.konga_users.id;


--
-- Name: konga_api_health_checks id; Type: DEFAULT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_api_health_checks ALTER COLUMN id SET DEFAULT nextval('public.konga_api_health_checks_id_seq'::regclass);


--
-- Name: konga_email_transports id; Type: DEFAULT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_email_transports ALTER COLUMN id SET DEFAULT nextval('public.konga_email_transports_id_seq'::regclass);


--
-- Name: konga_kong_nodes id; Type: DEFAULT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_kong_nodes ALTER COLUMN id SET DEFAULT nextval('public.konga_kong_nodes_id_seq'::regclass);


--
-- Name: konga_kong_services id; Type: DEFAULT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_kong_services ALTER COLUMN id SET DEFAULT nextval('public.konga_kong_services_id_seq'::regclass);


--
-- Name: konga_kong_snapshot_schedules id; Type: DEFAULT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_kong_snapshot_schedules ALTER COLUMN id SET DEFAULT nextval('public.konga_kong_snapshot_schedules_id_seq'::regclass);


--
-- Name: konga_kong_snapshots id; Type: DEFAULT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_kong_snapshots ALTER COLUMN id SET DEFAULT nextval('public.konga_kong_snapshots_id_seq'::regclass);


--
-- Name: konga_kong_upstream_alerts id; Type: DEFAULT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_kong_upstream_alerts ALTER COLUMN id SET DEFAULT nextval('public.konga_kong_upstream_alerts_id_seq'::regclass);


--
-- Name: konga_netdata_connections id; Type: DEFAULT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_netdata_connections ALTER COLUMN id SET DEFAULT nextval('public.konga_netdata_connections_id_seq'::regclass);


--
-- Name: konga_passports id; Type: DEFAULT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_passports ALTER COLUMN id SET DEFAULT nextval('public.konga_passports_id_seq'::regclass);


--
-- Name: konga_settings id; Type: DEFAULT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_settings ALTER COLUMN id SET DEFAULT nextval('public.konga_settings_id_seq'::regclass);


--
-- Name: konga_users id; Type: DEFAULT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_users ALTER COLUMN id SET DEFAULT nextval('public.konga_users_id_seq'::regclass);


--
-- Data for Name: konga_api_health_checks; Type: TABLE DATA; Schema: public; owner: hipayadmin
--

COPY public.konga_api_health_checks (id, api_id, api, health_check_endpoint, notification_endpoint, active, data, "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
\.


--
-- Data for Name: konga_email_transports; Type: TABLE DATA; Schema: public; owner: hipayadmin
--

COPY public.konga_email_transports (id, name, description, schema, settings, active, "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
1	smtp	Send emails using the SMTP protocol	[{"name":"host","description":"The SMTP host","type":"text","required":true},{"name":"port","description":"The SMTP port","type":"text","required":true},{"name":"username","model":"auth.user","description":"The SMTP user username","type":"text","required":true},{"name":"password","model":"auth.pass","description":"The SMTP user password","type":"text","required":true},{"name":"secure","model":"secure","description":"Use secure connection","type":"boolean"}]	{"host":"","port":"","auth":{"user":"","pass":""},"secure":false}	t	2019-04-15 06:32:20+00	2019-04-22 01:42:37+00	\N	\N
2	sendmail	Pipe messages to the sendmail command	\N	{"sendmail":true}	f	2019-04-15 06:32:20+00	2019-04-22 01:42:37+00	\N	\N
3	mailgun	Send emails through Mailgun’s Web API	[{"name":"api_key","model":"auth.api_key","description":"The API key that you got from www.mailgun.com/cp","type":"text","required":true},{"name":"domain","model":"auth.domain","description":"One of your domain names listed at your https://mailgun.com/app/domains","type":"text","required":true}]	{"auth":{"api_key":"","domain":""}}	f	2019-04-15 06:32:20+00	2019-04-22 01:42:37+00	\N	\N
\.


--
-- Data for Name: konga_kong_nodes; Type: TABLE DATA; Schema: public; owner: hipayadmin
--

COPY public.konga_kong_nodes (id, name, type, kong_admin_url, netdata_url, kong_api_key, jwt_algorithm, jwt_key, jwt_secret, kong_version, health_checks, health_check_details, active, "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
1	payer	default	http://10.0.11.6:8001	\N		HS256	\N	\N	1.1.1	f	\N	f	2019-04-16 07:26:07+00	2019-04-22 01:53:29+00	1	1
\.


--
-- Data for Name: konga_kong_services; Type: TABLE DATA; Schema: public; owner: hipayadmin
--

COPY public.konga_kong_services (id, service_id, kong_node_id, description, tags, "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
1	adddea66-54d3-46dd-b86c-31ab8678b514	1	\N	\N	2019-04-16 07:28:47+00	2019-04-22 01:53:45+00	\N	\N
\.


--
-- Data for Name: konga_kong_snapshot_schedules; Type: TABLE DATA; Schema: public; owner: hipayadmin
--

COPY public.konga_kong_snapshot_schedules (id, connection, active, cron, "lastRunAt", "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
\.


--
-- Data for Name: konga_kong_snapshots; Type: TABLE DATA; Schema: public; owner: hipayadmin
--

COPY public.konga_kong_snapshots (id, name, kong_node_name, kong_node_url, kong_version, data, "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
1	PayerV1-Snapshots_1	payer	http://10.0.10.190:8001	1.1.1	{"services":[{"host":"10.0.10.190","created_at":1555399727,"connect_timeout":60000,"id":"adddea66-54d3-46dd-b86c-31ab8678b514","protocol":"http","name":"upstream_8080","read_timeout":60000,"port":8080,"path":"/","updated_at":1555474030,"retries":5,"write_timeout":60000,"tags":[],"extras":{"id":1,"service_id":"adddea66-54d3-46dd-b86c-31ab8678b514","kong_node_id":"1","description":null,"tags":null,"createdAt":"2019-04-16T07:28:47.000Z","updatedAt":"2019-04-17T04:07:10.000Z","createdUser":null,"updatedUser":null}}],"routes":[{"updated_at":1555474795,"created_at":1555474795,"strip_path":false,"snis":null,"hosts":["localhost"],"name":"v0_applications","methods":null,"sources":null,"preserve_host":true,"regex_priority":0,"service":{"id":"adddea66-54d3-46dd-b86c-31ab8678b514"},"paths":["/applications"],"destinations":null,"id":"0c8f9960-cc82-4243-a5a8-abe6a73107af","protocols":["http","https"],"tags":null},{"updated_at":1555474058,"created_at":1555416574,"strip_path":false,"snis":null,"hosts":["localhost"],"name":"v1_payments","methods":["GET","POST","PATCH"],"sources":null,"preserve_host":true,"regex_priority":0,"service":{"id":"adddea66-54d3-46dd-b86c-31ab8678b514"},"paths":["/v1/payments"],"destinations":null,"id":"4b8e8fe6-6e7b-4953-9068-a11edba2219c","protocols":["http","https"],"tags":null},{"updated_at":1555474720,"created_at":1555474443,"strip_path":false,"snis":null,"hosts":["localhost"],"name":"v0_refunds","methods":["GET"],"sources":null,"preserve_host":true,"regex_priority":0,"service":{"id":"adddea66-54d3-46dd-b86c-31ab8678b514"},"paths":["/refunds"],"destinations":null,"id":"71cb8392-85ce-44ea-b529-f6fe37ddd4f8","protocols":["http","https"],"tags":null},{"updated_at":1555474073,"created_at":1555399891,"strip_path":false,"snis":null,"hosts":["localhost"],"name":"v1_applications","methods":["GET","POST","PATCH"],"sources":null,"preserve_host":true,"regex_priority":0,"service":{"id":"adddea66-54d3-46dd-b86c-31ab8678b514"},"paths":["/v1/applications"],"destinations":null,"id":"b26dca1f-9e4c-49a9-8eb1-a85a49f558a4","protocols":["http","https"],"tags":null},{"updated_at":1555474705,"created_at":1555474151,"strip_path":false,"snis":null,"hosts":["localhost"],"name":"v0_config","methods":["GET"],"sources":null,"preserve_host":true,"regex_priority":0,"service":{"id":"adddea66-54d3-46dd-b86c-31ab8678b514"},"paths":["/config"],"destinations":null,"id":"b8570cab-f76a-41c0-ace0-c9a6d21c189f","protocols":["http","https"],"tags":null},{"updated_at":1555474664,"created_at":1555474252,"strip_path":false,"snis":null,"hosts":["localhost"],"name":"v0_payments","methods":["GET","POST","PATCH"],"sources":null,"preserve_host":true,"regex_priority":0,"service":{"id":"adddea66-54d3-46dd-b86c-31ab8678b514"},"paths":["/payments"],"destinations":null,"id":"c4a57d38-4984-4db7-92e3-589904cc190d","protocols":["http","https"],"tags":null},{"updated_at":1555474043,"created_at":1555416597,"strip_path":false,"snis":null,"hosts":["localhost"],"name":"v1_refunds","methods":["GET","POST","PATCH"],"sources":null,"preserve_host":true,"regex_priority":0,"service":{"id":"adddea66-54d3-46dd-b86c-31ab8678b514"},"paths":["/v1/refunds"],"destinations":null,"id":"fc30f246-f427-41b0-af77-8a0df5b0f489","protocols":["http","https"],"tags":null}],"consumers":[],"plugins":[{"created_at":1555415748,"config":{"methods":["GET","POST","PATCH"],"exposed_headers":["payment_id","refund_id"],"max_age":86400,"headers":["Content-Type","Accept","Date","Content-Length","X-Api-Key","X-Payment-Request-ID","X-Refund-Request-ID","X-Request-Id","Accept-Version"],"origins":["*"],"credentials":true,"preflight_continue":false},"id":"0a1b70d8-c71c-44a4-99b7-ab3b67a0470a","service":null,"name":"cors","protocols":["http","https"],"enabled":true,"run_on":"first","consumer":null,"route":null,"tags":null}],"acls":[],"upstreams":[],"certificates":[],"snis":[]}	2019-04-17 07:24:49+00	2019-04-17 07:24:49+00	\N	\N
\.


--
-- Data for Name: konga_kong_upstream_alerts; Type: TABLE DATA; Schema: public; owner: hipayadmin
--

COPY public.konga_kong_upstream_alerts (id, upstream_id, connection, email, slack, cron, active, data, "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
\.


--
-- Data for Name: konga_netdata_connections; Type: TABLE DATA; Schema: public; owner: hipayadmin
--

COPY public.konga_netdata_connections (id, "apiId", url, "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
\.


--
-- Data for Name: konga_passports; Type: TABLE DATA; Schema: public; owner: hipayadmin
--

COPY public.konga_passports (id, protocol, password, provider, identifier, tokens, "user", "createdAt", "updatedAt") FROM stdin;
1	local	$2a$10$UQJjxhERInE6wwV76uul6OD71tTC7UtcWv7gw1JRdWCbhr2ANQ27q	\N	\N	\N	1	2019-04-15 06:50:04+00	2019-04-15 06:50:04+00
\.


--
-- Data for Name: konga_settings; Type: TABLE DATA; Schema: public; owner: hipayadmin
--

COPY public.konga_settings (id, data, "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
1	{"signup_enable":true,"signup_require_activation":true,"info_polling_interval":10000,"email_default_sender_name":"KONGA","email_default_sender":"konga@konga.test","email_notifications":false,"default_transport":"sendmail","notify_when":{"node_down":{"title":"A node is down or unresponsive","description":"Health checks must be enabled for the nodes that need to be monitored.","active":true},"api_down":{"title":"An API is down or unresponsive","description":"Health checks must be enabled for the APIs that need to be monitored.","active":true}},"integrations":[{"id":"slack","name":"Slack","image":"slack_rgb.png","config":{"enabled":true,"fields":[{"id":"slack_webhook_url","name":"Slack Webhook URL","type":"text","required":true,"value":"https://hooks.slack.com/services/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"}],"slack_webhook_url":""}}],"user_permissions":{"apis":{"create":false,"read":true,"update":false,"delete":false},"services":{"create":false,"read":true,"update":false,"delete":false},"routes":{"create":false,"read":true,"update":false,"delete":false},"consumers":{"create":false,"read":true,"update":false,"delete":false},"plugins":{"create":false,"read":true,"update":false,"delete":false},"upstreams":{"create":false,"read":true,"update":false,"delete":false},"certificates":{"create":false,"read":true,"update":false,"delete":false},"connections":{"create":false,"read":true,"update":false,"delete":false},"users":{"create":false,"read":true,"update":false,"delete":false}}}	2019-04-15 06:32:20+00	2019-04-22 01:42:37+00	\N	\N
\.


--
-- Data for Name: konga_users; Type: TABLE DATA; Schema: public; owner: hipayadmin
--

COPY public.konga_users (id, username, email, "firstName", "lastName", admin, node_id, active, "activationToken", node, "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
1	wangxiaofeng	xiaofeng.wang@tinklabs.com	\N	\N	t		t	93d490a7-98c1-4101-9ffb-f6a34a898026	1	2019-04-15 06:50:03+00	2019-04-22 01:53:29+00	\N	1
\.


--
-- Name: konga_api_health_checks_id_seq; Type: SEQUENCE SET; Schema: public; owner: hipayadmin
--

SELECT pg_catalog.setval('public.konga_api_health_checks_id_seq', 1, false);


--
-- Name: konga_email_transports_id_seq; Type: SEQUENCE SET; Schema: public; owner: hipayadmin
--

SELECT pg_catalog.setval('public.konga_email_transports_id_seq', 3, true);


--
-- Name: konga_kong_nodes_id_seq; Type: SEQUENCE SET; Schema: public; owner: hipayadmin
--

SELECT pg_catalog.setval('public.konga_kong_nodes_id_seq', 1, true);


--
-- Name: konga_kong_services_id_seq; Type: SEQUENCE SET; Schema: public; owner: hipayadmin
--

SELECT pg_catalog.setval('public.konga_kong_services_id_seq', 1, true);


--
-- Name: konga_kong_snapshot_schedules_id_seq; Type: SEQUENCE SET; Schema: public; owner: hipayadmin
--

SELECT pg_catalog.setval('public.konga_kong_snapshot_schedules_id_seq', 1, false);


--
-- Name: konga_kong_snapshots_id_seq; Type: SEQUENCE SET; Schema: public; owner: hipayadmin
--

SELECT pg_catalog.setval('public.konga_kong_snapshots_id_seq', 1, true);


--
-- Name: konga_kong_upstream_alerts_id_seq; Type: SEQUENCE SET; Schema: public; owner: hipayadmin
--

SELECT pg_catalog.setval('public.konga_kong_upstream_alerts_id_seq', 1, false);


--
-- Name: konga_netdata_connections_id_seq; Type: SEQUENCE SET; Schema: public; owner: hipayadmin
--

SELECT pg_catalog.setval('public.konga_netdata_connections_id_seq', 1, false);


--
-- Name: konga_passports_id_seq; Type: SEQUENCE SET; Schema: public; owner: hipayadmin
--

SELECT pg_catalog.setval('public.konga_passports_id_seq', 1, true);


--
-- Name: konga_settings_id_seq; Type: SEQUENCE SET; Schema: public; owner: hipayadmin
--

SELECT pg_catalog.setval('public.konga_settings_id_seq', 1, true);


--
-- Name: konga_users_id_seq; Type: SEQUENCE SET; Schema: public; owner: hipayadmin
--

SELECT pg_catalog.setval('public.konga_users_id_seq', 1, true);


--
-- Name: konga_api_health_checks konga_api_health_checks_api_id_key; Type: CONSTRAINT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_api_health_checks
    ADD CONSTRAINT konga_api_health_checks_api_id_key UNIQUE (api_id);


--
-- Name: konga_api_health_checks konga_api_health_checks_pkey; Type: CONSTRAINT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_api_health_checks
    ADD CONSTRAINT konga_api_health_checks_pkey PRIMARY KEY (id);


--
-- Name: konga_email_transports konga_email_transports_name_key; Type: CONSTRAINT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_email_transports
    ADD CONSTRAINT konga_email_transports_name_key UNIQUE (name);


--
-- Name: konga_email_transports konga_email_transports_pkey; Type: CONSTRAINT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_email_transports
    ADD CONSTRAINT konga_email_transports_pkey PRIMARY KEY (id);


--
-- Name: konga_kong_nodes konga_kong_nodes_pkey; Type: CONSTRAINT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_kong_nodes
    ADD CONSTRAINT konga_kong_nodes_pkey PRIMARY KEY (id);


--
-- Name: konga_kong_services konga_kong_services_pkey; Type: CONSTRAINT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_kong_services
    ADD CONSTRAINT konga_kong_services_pkey PRIMARY KEY (id);


--
-- Name: konga_kong_services konga_kong_services_service_id_key; Type: CONSTRAINT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_kong_services
    ADD CONSTRAINT konga_kong_services_service_id_key UNIQUE (service_id);


--
-- Name: konga_kong_snapshot_schedules konga_kong_snapshot_schedules_pkey; Type: CONSTRAINT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_kong_snapshot_schedules
    ADD CONSTRAINT konga_kong_snapshot_schedules_pkey PRIMARY KEY (id);


--
-- Name: konga_kong_snapshots konga_kong_snapshots_name_key; Type: CONSTRAINT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_kong_snapshots
    ADD CONSTRAINT konga_kong_snapshots_name_key UNIQUE (name);


--
-- Name: konga_kong_snapshots konga_kong_snapshots_pkey; Type: CONSTRAINT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_kong_snapshots
    ADD CONSTRAINT konga_kong_snapshots_pkey PRIMARY KEY (id);


--
-- Name: konga_kong_upstream_alerts konga_kong_upstream_alerts_pkey; Type: CONSTRAINT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_kong_upstream_alerts
    ADD CONSTRAINT konga_kong_upstream_alerts_pkey PRIMARY KEY (id);


--
-- Name: konga_kong_upstream_alerts konga_kong_upstream_alerts_upstream_id_key; Type: CONSTRAINT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_kong_upstream_alerts
    ADD CONSTRAINT konga_kong_upstream_alerts_upstream_id_key UNIQUE (upstream_id);


--
-- Name: konga_netdata_connections konga_netdata_connections_pkey; Type: CONSTRAINT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_netdata_connections
    ADD CONSTRAINT konga_netdata_connections_pkey PRIMARY KEY (id);


--
-- Name: konga_passports konga_passports_pkey; Type: CONSTRAINT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_passports
    ADD CONSTRAINT konga_passports_pkey PRIMARY KEY (id);


--
-- Name: konga_settings konga_settings_pkey; Type: CONSTRAINT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_settings
    ADD CONSTRAINT konga_settings_pkey PRIMARY KEY (id);


--
-- Name: konga_users konga_users_email_key; Type: CONSTRAINT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_users
    ADD CONSTRAINT konga_users_email_key UNIQUE (email);


--
-- Name: konga_users konga_users_pkey; Type: CONSTRAINT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_users
    ADD CONSTRAINT konga_users_pkey PRIMARY KEY (id);


--
-- Name: konga_users konga_users_username_key; Type: CONSTRAINT; Schema: public; owner: hipayadmin
--

ALTER TABLE ONLY public.konga_users
    ADD CONSTRAINT konga_users_username_key UNIQUE (username);


--
-- PostgreSQL database dump complete
--

