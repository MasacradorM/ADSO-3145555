package sena.cafetin.service;

import sena.cafetin.entity.Usuario;
import sena.cafetin.repository.UsuarioRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class UsuarioService {
    private final UsuarioRepository repo;
    public UsuarioService(UsuarioRepository repo) { this.repo = repo; }

    public List<Usuario> findAll() { return repo.findAll(); }
    public Optional<Usuario> findById(Long id) { return repo.findById(id); }
    public Usuario save(Usuario usuario) { return repo.save(usuario); }
    public void delete(Long id) { repo.deleteById(id); }
}