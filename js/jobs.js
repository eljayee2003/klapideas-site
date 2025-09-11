fetch('/jobs.json')
  .then(r => r.json())
  .then(jobs => {
    const el = document.getElementById('jobs');
    if (!jobs.length) { el.innerHTML = "<p>No openings right now. Check back soon.</p>"; return; }
    el.innerHTML = jobs.map(j => `
      <article>
        <header><h3>${j.title}</h3><small>${j.team} • ${j.location}</small></header>
        <p>${j.summary}</p>
        <a role="button" href="mailto:careers@klapideas.com?subject=${encodeURIComponent(j.title)}">Apply</a>
      </article>
    `).join('');
  })
  .catch(() => (document.getElementById('jobs').innerHTML = "<p>Couldn't load roles.</p>"));
