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
          items: [
            // Each item here is one entry in the navigation menu.
            { label: "Overview", link: "/overview/overview/" },
          ],
        },
        {
          label: "The API",
          autogenerate: { directory: "api" },
        },
        {
          label: "Decisions",
          autogenerate: { directory: "decisions" },
        },
      ],
    }),
  ],
});
