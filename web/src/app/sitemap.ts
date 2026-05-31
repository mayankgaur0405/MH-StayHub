import type { MetadataRoute } from 'next';
import { SITE_URL, API_BASE_URL } from '@/constants';
import type { ApiResponse, College, Accommodation } from '@/types';

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const staticRoutes: MetadataRoute.Sitemap = [
    { url: SITE_URL, lastModified: new Date(), changeFrequency: 'daily', priority: 1 },
    { url: `${SITE_URL}/colleges`, lastModified: new Date(), changeFrequency: 'weekly', priority: 0.8 },
    { url: `${SITE_URL}/accommodations`, lastModified: new Date(), changeFrequency: 'daily', priority: 0.9 },
    { url: `${SITE_URL}/about`, lastModified: new Date(), changeFrequency: 'monthly', priority: 0.5 },
    { url: `${SITE_URL}/contact`, lastModified: new Date(), changeFrequency: 'monthly', priority: 0.5 },
  ];

  // Dynamically fetch college and accommodation slugs for SEO
  let collegeRoutes: MetadataRoute.Sitemap = [];
  let accommodationRoutes: MetadataRoute.Sitemap = [];

  try {
    const collegesRes = await fetch(`${API_BASE_URL}/colleges`, { next: { revalidate: 3600 } });
    if (collegesRes.ok) {
      const colleges: ApiResponse<College[]> = await collegesRes.json();
      collegeRoutes = colleges.data.map((college) => ({
        url: `${SITE_URL}/colleges/${college.slug}`,
        lastModified: new Date(college.updatedAt),
        changeFrequency: 'weekly' as const,
        priority: 0.7,
      }));
    }
  } catch { /* fail silently */ }

  try {
    const accRes = await fetch(`${API_BASE_URL}/accommodations`, { next: { revalidate: 300 } });
    if (accRes.ok) {
      const accommodations: ApiResponse<Accommodation[]> = await accRes.json();
      accommodationRoutes = accommodations.data.map((acc) => ({
        url: `${SITE_URL}/accommodations/${acc.slug}`,
        lastModified: new Date(acc.updatedAt),
        changeFrequency: 'daily' as const,
        priority: 0.8,
      }));
    }
  } catch { /* fail silently */ }

  return [...staticRoutes, ...collegeRoutes, ...accommodationRoutes];
}
