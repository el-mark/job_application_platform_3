import React, { useEffect, useState } from 'react';

function App() {
  const [applicants, setApplicants] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch('http://127.0.0.1:3000/applicants')
      .then((response) => {
        if (!response.ok) {
          throw new Error('Error al obtener los datos');
        }
        return response.json();
      })
      .then((data) => {
        const sortedData = data.sort((a, b) => b.ai_result - a.ai_result);
        setApplicants(sortedData);
        setLoading(false);
      })
      .catch((error) => {
        setError(error.message);
        setLoading(false);
      });
  }, []);

  if (loading) return <div>Cargando...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div className="App">
      <h1>Lista de Candidatos</h1>
      <ul>
        {applicants.map((applicant) => (
          <li key={applicant.id} style={{ marginBottom: '1rem', borderBottom: '1px solid #ccc', paddingBottom: '1rem' }}>
            <h2>
              {applicant.names} - <span>IA: {applicant.ai_result}</span>
            </h2>
            <p><strong>Teléfono:</strong> {applicant.phone}</p>
            <p><strong>Experiencia Laboral:</strong> {applicant.work_experience}</p>
            <p><strong>Educación:</strong> {applicant.education}</p>
            <p><strong>Descripción de resultado:</strong> {applicant.ai_result_description}</p>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App;