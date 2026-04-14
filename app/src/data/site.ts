export const site = {
	name: 'Psychedelic Institute',
	description: 'Community, education, events, and membership for the Psychedelic Institute.',
	loginUrl: 'https://billing.stripe.com/p/login/bIYbL3gul1k5boAcMM',
	circleContributorUrl: 'https://awakening-events-pila-361df6.circle.so/checkout/contributor-membership',
	circleInnerCircleUrl: 'https://awakening-events-pila-361df6.circle.so/checkout/inner-circle',
	vimeoUrl: 'https://vimeo.com/1047750694/8ca5d60a50',
	youtubeUrl: 'https://youtu.be/_H500lVkBVU',
	givebutterUrl: 'https://givebutter.com/psychedelic-institute-shdcjx',
};

export const homeSections = {
	hero: {
		eyebrow: 'Awakening Community',
		title: 'Connecting the psychedelic community through education, events, and healing stories.',
		intro:
			'Welcome to the Psychedelic Institute, a nonprofit community in LA dedicated to healing lives through neural, personal, and cultural connection.',
		primaryCta: { label: 'Explore Membership', href: '/membership' },
		secondaryCta: { label: 'Watch The Movement', href: site.vimeoUrl },
	},
	featureCards: [
		{
			title: 'Online Community',
			body: 'Stay connected 24/7 through the community portal, discussions, trainings, and updates.',
		},
		{
			title: 'In-Person Events',
			body: 'Psychedelic Awakening events bring researchers, healers, therapists, activists, and seekers into the same room.',
		},
		{
			title: 'Healing Stories',
			body: 'Story after story of transformation helps break stigma and spread the good news of healing.',
		},
	],
	community: {
		title: 'A community of seekers and experienced healers',
		body: 'The institute brings together researchers, indigenous perspectives, therapists, facilitators, brands, activists, and people seeking healing for themselves and their loved ones. The purpose is shared: heal together, scale faster together, and make the movement visible.',
		stats: [
			{ value: '2000+', label: 'In-person community members' },
			{ value: '47+', label: 'Speakers featured' },
			{ value: '12', label: 'Live music performances' },
		],
	},
	memberExperience: {
		title: 'Daily connection, weekly calls, monthly events',
		body: 'A simple rhythm: check in daily, join support and training sessions weekly, and meet in person each month.',
		items: [
			{
				title: 'Daily Connection',
				body: 'Log in daily and stay connected with members, updates, and community discussion.',
			},
			{
				title: 'Weekly Zoom Calls',
				body: 'Weekly sessions provide support, trainings, and updates on the latest events and news.',
			},
			{
				title: 'Monthly In-Person Events',
				body: 'Attend live events or use the network as a launch point for community chapters in other cities.',
			},
		],
	},
	membership: {
		title: 'Membership Your Way',
		body: 'Multiple monthly donation tiers support the movement at different levels of involvement.',
		tiers: [
			{
				name: 'Contributor',
				price: 'From $9.97 / month',
				features: [
					'Access to group chats with experts',
					'Monthly in-person and online events',
					'Contributor discounts',
				],
				cta: { label: 'Get Access', href: site.circleContributorUrl },
			},
			{
				name: 'Inner Circle',
				price: 'From $29 / month',
				features: [
					'Private group chats with experts',
					'Video training and workshop access',
					'VIP access and event discounts',
				],
				cta: { label: 'Join Inner Circle', href: site.circleInnerCircleUrl },
			},
			{
				name: 'Guardian',
				price: 'Application-based',
				features: [
					'Private guardian retreats',
					'VIP access to all events',
					'Macro-donation support for scaling the movement',
				],
				cta: { label: 'Apply Now', href: '/guardian' },
			},
		],
	},
	donation: {
		title: 'Why donate?',
		body: 'Your one-time donation supports research, education, certification, and public-facing events around psychedelic-assisted therapies.',
		amounts: [
			{ value: 50, label: '$50' },
			{ value: 100, label: '$100' },
			{ value: 250, label: '$250' },
			{ value: 500, label: '$500' },
			{ value: null, label: 'Other amount' },
		],
		cta: { label: 'Donate Now', href: '/donate' },
	},
	testimonials: {
		title: 'Why others recommend us',
		items: [
			{
				quote: 'Love this community',
				body: '',
			},
			{
				quote: 'My life changed forever thanks to plant medicine',
				body: '',
			},
			{
				quote: 'Life changing connections',
				body: '',
			},
		],
	},
	footerCta: {
		title: 'Community, training, and updates in one place.',
		body: 'Join the community and stay connected with events, training, and updates.',
		cta: { label: 'View Membership Options', href: '/membership' },
	},
};

export const membershipPage = {
	title: 'Membership Options',
	intro:
		'Contributor, inner circle, and guardian membership options, plus one-time donations to support the movement.',
	donationNote:
		'Support the movement with a one-time donation. Every contribution funds research, education, and community events.',
};

export const donatePage = {
	title: 'Support the Movement',
	intro:
		'Your one-time donation funds psychedelic research, education, certification programs, and community events that change lives.',
	whyDonate: [
		'Fund cutting-edge psychedelic research and clinical trials',
		'Support education and certification for therapists and facilitators',
		'Enable free and subsidized community events',
		'Advance policy reform and public awareness',
	],
};

export const guardianPage = {
	title: 'Guardian Application',
	intro:
		'Apply to become a guardian and support the movement at the highest level.',
	note: 'Guardians receive access to private retreats, VIP event access, and direct involvement in scaling the mission.',
};

export const thankYouPage = {
	title: 'Thank You',
	body: 'Thank you. We will be in touch.',
};
