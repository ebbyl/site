import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";

// https://astro.build/config
export default defineConfig({
  site: "https://ebbyl.github.io",
  base: "site",
  integrations: [
    starlight({
      title: "EBBYL",
      social: {
        github: "https://github.com/withastro/starlight",
      },
      sidebar: [
        {
          label: "Overview",
          items: [{ label: "Overview", link: "/overview/overview/" }],
        },
        {
          label: "API",
          items: [
            { label: "API Overview", link: "/api/api/" },
            { label: "DNS", link: "/api/dns/" },
            { label: "HTTPS", link: "/api/https/" },
            { label: "Authentication", link: "/api/auth/" },
            { label: "Usage Limits", link: "/api/usage/" },
            { label: "Portability", link: "/api/portability/" },
          ],
        },
        {
          label: "CI/CD",
          items: [
            { label: "Overview", link: "/ci/overview/" },
            { label: "Modularity", link: "/ci/modules/" },
            { label: "Open Source", link: "/ci/oss/" },
            { label: "OIDC", link: "/ci/oidc/" },
          ],
        },
      ],
    }),
  ],
});
