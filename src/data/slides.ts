export interface Slide {
  kicker: string;
  title: string;
  body: string;
  /** Relative path (no leading slash) so the page also works from file:// or a subpath. Omit to show the large QR code instead. */
  image?: string;
  imageAlt?: string;
  /** "cover" crops photos to fill the frame; "contain" shows posters/illustrations whole on a white card. */
  fit?: 'cover' | 'contain';
  /** Seconds on screen. Defaults to DEFAULT_DURATION. */
  duration?: number;
}

export const DEFAULT_DURATION = 12;

// Copy and images sourced from the manheim-lions-website repo.
// Images live in public/slides/, pre-resized to fit within 1200px.
export const slides: Slide[] = [
  {
    kicker: 'Serving Manheim since 1925',
    title: 'We Serve.',
    body: 'For 100 years the Manheim Lions Club has served the heart of Lancaster County, as part of Lions Clubs International: 1.4 million neighbors helping neighbors.',
    image: './slides/logo.webp',
    imageAlt: 'Lions Clubs International logo',
    fit: 'contain',
  },
  {
    kicker: 'Free for neighbors in need',
    title: 'Medical Equipment Loans',
    body: 'Wheelchairs, travel wheelchairs, walkers, and canes, loaned free of charge to Manheim residents recovering from surgery or facing a mobility challenge.',
    image: './slides/medical-equipment.webp',
    imageAlt: 'Wheelchair, walker, and cane',
    fit: 'contain',
  },
  {
    kicker: 'The gift of sight',
    title: 'Eyeglass Recycling',
    body: 'Drop your old glasses and cases in our boxes around town. They are cleaned, sorted by prescription, and given to people in need around the world.',
    image: './slides/eyeglasses-box.webp',
    imageAlt: 'Lions eyeglass donation box',
    fit: 'cover',
  },
  {
    kicker: 'Every spring',
    title: 'Community Clean-up',
    body: 'Manheim residents get a free way to clear out clutter, with on-site dumpsters, secure document shredding, and metal recycling.',
    image: './slides/cleanup-page-img.webp',
    imageAlt: 'Manheim Lions Club Spring Clean-up flyer',
    fit: 'contain',
  },
  {
    kicker: 'Every Easter',
    title: 'Egg Hunts for Every Kid',
    body: 'A free hunt for ages 0–12, plus a hunt for visually impaired kids using eggs that beep so they can be found by sound.',
    image: './slides/egg-hunt-poster-vp.webp',
    imageAlt: 'Easter Egg Hunt for Visually Impaired Kids poster',
    fit: 'contain',
  },
  {
    kicker: 'Investing in youth',
    title: 'Cub Scout Pack 47',
    body: 'We proudly sponsor Cub Scout Pack 47 and its annual Pinewood Derby, where Scouts design, build, and race their own cars.',
    image: './slides/derby1.webp',
    imageAlt: 'Pinewood Derby cars lined up on a table',
    fit: 'cover',
  },
  {
    kicker: 'Sponsored since 1975',
    title: 'Manheim Lions 14U Baseball',
    body: 'Uniforms, equipment, and support for young athletes learning teamwork, sportsmanship, and community pride. Go Lions!',
    image: './slides/baseball-team.webp',
    imageAlt: 'Manheim Lions 14U baseball team photo',
    fit: 'cover',
  },
  {
    kicker: 'Every December',
    title: 'Santa 5K Run & Walk',
    body: 'Festive runners and walkers take over downtown Manheim, starting and finishing in Market Square. All ages welcome, and every step supports local projects.',
    image: './slides/santa-5k-1.webp',
    imageAlt: 'Runners in holiday outfits at the Santa 5K',
    fit: 'cover',
  },
  {
    kicker: 'Thank you!',
    title: 'Your Purchase Makes It Possible',
    body: 'Every sandwich, broom, and Maker’s Market sale funds this work. All money raised goes straight back into serving our community.',
    image: './slides/fund-brooms.webp',
    imageAlt: 'Lions Club fundraiser brooms',
    fit: 'cover',
  },
  {
    kicker: 'Want to help?',
    title: 'Become a Lion',
    body: 'Come to a meeting and see what we’re about. Scan to visit manheimlions.org.',
    duration: 15,
  },
];
