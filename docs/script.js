document.addEventListener('DOMContentLoaded', () => {
    lucide.createIcons();

    const sidebarItems = document.querySelectorAll('.sidebar-nav li');
    const sections = document.querySelectorAll('.doc-section');
    const searchInput = document.getElementById('search-input');
    const copyButtons = document.querySelectorAll('.copy-btn');

    function switchSection(targetId) {
        sections.forEach(sec => sec.classList.remove('active-section'));
        sidebarItems.forEach(item => item.classList.remove('active'));

        const targetSec = document.getElementById(targetId);
        if (targetSec) {
            targetSec.classList.add('active-section');
        }

        const activeItem = document.querySelector(`.sidebar-nav li[data-target="${targetId}"]`);
        if (activeItem) {
            activeItem.classList.add('active');
        }
        
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    sidebarItems.forEach(item => {
        item.addEventListener('click', (e) => {
            e.preventDefault();
            const targetId = item.getAttribute('data-target');
            switchSection(targetId);
            history.pushState(null, null, `#${targetId}`);
        });
    });

    window.addEventListener('popstate', () => {
        const hash = window.location.hash.substring(1);
        if (hash) {
            switchSection(hash);
        }
    });

    const initialHash = window.location.hash.substring(1);
    if (initialHash) {
        switchSection(initialHash);
    }

    copyButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            const pre = btn.parentElement.nextElementSibling;
            const code = pre.querySelector('code');
            navigator.clipboard.writeText(code.innerText).then(() => {
                const originalHtml = btn.innerHTML;
                btn.innerHTML = `<i data-lucide="check"></i> Copied!`;
                lucide.createIcons();
                setTimeout(() => {
                    btn.innerHTML = originalHtml;
                    lucide.createIcons();
                }, 2000);
            });
        });
    });

    searchInput.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase();
        
        sidebarItems.forEach(item => {
            const text = item.textContent.toLowerCase();
            if (text.includes(query)) {
                item.style.display = 'block';
            } else {
                item.style.display = 'none';
            }
        });
    });
});
