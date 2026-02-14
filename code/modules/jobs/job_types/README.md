### Adding a Job

This is pretty straight forward, and this file serves mostly as a checklist.

Copy an existing job datum, and tweak it to your liking. I'm not gonna write the specifics down on this one as I'm not even going to pretend people will keep this readme up to date.

For other places:

- `job_display_order` list in `code/modules/jobs/job_types/_job.dm` to insert your job in the right place.
    - This decides where the job sits relative to others inside the crew monitor and latejoin screens.
- You will also want to make at least one title datum.
- And you will also want to create a custom outfit, and assign it to the human species in the title datum **at least**. Every crew-facing title **must** have a human entry for fallback reasons, other species are optional.
